#!/usr/bin/env bats
set -a
BATS_VERSION=0.4.0
KUBECTL_CONTEXT="cluster-medium"

setup() {
    load /code/test/mocks/kubectl
}

teardown() {
    echo "Tests complete"
}

switch_context() {
    kubectl config use-context $1
    run kubectl config current-context
    echo "context= ${output}"
    [ $status -eq 0 ]
    [[ "${lines[0]}" == "${1}" ]]
}

@test "kubectl view utilization -v" {

    run /code/kubectl-view-utilization -v
    [ $status -eq 0 ]
    echo "output = ${output}"
    [[ "$output" == v* ]]
}


@test "cluster-small> kubectl get nodes allocatable cpu and memory" {

    switch_context cluster-small

    run kubectl get nodes -o=jsonpath="{range .items[*]}{.metadata.name}{'\t'}{.status.allocatable.cpu}{'\t'}{.status.allocatable.memory}{'\n'}{end}"
    [ $status -eq 0 ]
    [[ "${lines[0]}" == "ip-10-1-1-10.us-west-2.compute.internal	449m	1351126Ki" ]]
    [[ "${lines[1]}" == "ip-10-1-1-11.us-west-2.compute.internal	449m	1351126Ki" ]]
}

@test "cluster-medium> kubectl get nodes allocatable cpu and memory" {

    switch_context cluster-medium
    run kubectl get nodes -o=jsonpath="{range .items[*]}{.metadata.name}{'\t'}{.status.allocatable.cpu}{'\t'}{.status.allocatable.memory}{'\n'}{end}"
    [ $status -eq 0 ]
    [[ "${lines[0]}" == "ip-10-1-1-10.us-west-2.compute.internal	940m	2702252Ki" ]]
    [[ "${lines[3]}" == "ip-10-1-1-14.us-west-2.compute.internal	8	31700424Ki" ]]
}

@test "cluster-big> kubectl get nodes allocatable cpu and memory" {

    switch_context cluster-big
    run kubectl get nodes -o=jsonpath="{range .items[*]}{.metadata.name}{'\t'}{.status.allocatable.cpu}{'\t'}{.status.allocatable.memory}{'\n'}{end}"
    [ $status -eq 0 ]
    [[ "${lines[2]}" == "ip-10-1-1-14.us-west-2.compute.internal	4	15850212Ki" ]]
    [[ "${lines[6]}" == "ip-10-1-1-18.us-west-2.compute.internal	16	63400848Ki" ]]
    [[ "${lines[26]}" == "ip-10-1-1-38.us-west-2.compute.internal	32	63400848Ki" ]]

}

@test "cluster-small> kubectl get pod requests cpu and memory" {

    switch_context cluster-small
    run kubectl get pod --all-namespaces --field-selector=status.phase=Running -o=go-template -o=jsonpath="{{/* get_pod_data */}}"
    [ $status -eq 0 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "default	ip-10-1-1-10.us-west-2.compute.internal	10m	" ]]
    [[ "${lines[1]}" == "default	ip-10-1-1-11.us-west-2.compute.internal		" ]]
    [[ "${lines[2]}" == "default	ip-10-1-1-10.us-west-2.compute.internal	50m	300Mi" ]]
}

@test "cluster-medium> kubectl get pod requests cpu and memory" {

    switch_context cluster-medium
    run kubectl get pod --all-namespaces --field-selector=status.phase=Running -o=go-template -o=jsonpath="{{/* get_pod_data */}}"
    [ $status -eq 0 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "kube-system	ip-10-1-1-10.us-west-2.compute.internal	10m	" ]]
}

@test "cluster-big> kubectl get pod requests cpu and memory" {

    switch_context cluster-big
    run kubectl get pod --all-namespaces --field-selector=status.phase=Running -o=go-template -o=jsonpath="{{/* get_pod_data */}}"
    [ $status -eq 0 ]
    echo "output = ${output}"
    echo "it should be: ${lines[14]}"
    [[ "${lines[0]}" == "default	ip-10-1-1-10.us-west-2.compute.internal	10m	" ]]
    [[ "${lines[7]}" == "kube-system	ip-10-1-1-15.us-west-2.compute.internal	5m	32Mi" ]]
    [[ "${lines[14]}" == "qa	ip-10-1-1-15.us-west-2.compute.internal	2	1G" ]]
}

@test "cluster-small> kubectl view utilization" {

    switch_context cluster-small
    run /code/kubectl-view-utilization
    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "cores   0.07 / 0.9   (7%)" ]]
    [[ "${lines[1]}" == "memory  364M / 2.6G  (13%)" ]]
}

@test "cluster-medium> kubectl view utilization" {

    switch_context cluster-medium
    run /code/kubectl-view-utilization
    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "cores     20 / 29    (69%)" ]]
    [[ "${lines[1]}" == "memory   13G / 111G  (11%)" ]]
}

@test "cluster-big> kubectl view utilization" {

    switch_context cluster-big
    run /code/kubectl-view-utilization
    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "cores     98 / 538   (18%)" ]]
    [[ "${lines[1]}" == "memory  144G / 1.6T  (8%)" ]]
}

@test "cluster-small> kubectl view-utilization namespaces" {

    switch_context cluster-small
    run /code/kubectl-view-utilization namespaces
    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "NAMESPACE         CPU    MEMORY" ]]
    [[ "${lines[2]}" == "kube-system      0.01       64M" ]]
}

@test "cluster-medium> kubectl view-utilization namespaces" {

    switch_context cluster-medium
    run /code/kubectl-view-utilization namespaces
    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "NAMESPACE         CPU    MEMORY" ]]
    [[ "${lines[1]}" == "qa                 18       11G" ]]
    [[ "${lines[3]}" == "kube-system         1      512M" ]]
}

@test "cluster-big> kubectl view-utilization namespaces" {

    switch_context cluster-big
    run /code/kubectl-view-utilization namespaces
    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "NAMESPACE        CPU    MEMORY" ]]
    [[ "${lines[1]}" == "stg               30       60G" ]]
    [[ "${lines[3]}" == "default         0.02         0" ]]
    [[ "${lines[6]}" == "kube-system     0.27      434M" ]]
}

@test "cluster-small> kubectl view-utilization masters" {

    switch_context cluster-small
    run /code/kubectl-view-utilization -l node-role.kubernetes.io/master=true
    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "cores   0.06 / 0.45  (13%)" ]]
    [[ "${lines[1]}" == "memory  300M / 1.3G  (22%)" ]]
}

@test "cluster-medium> kubectl view-utilization masters" {

    switch_context cluster-medium
    run /code/kubectl-view-utilization -l node-role.kubernetes.io/master=true
    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "cores    4.3 / 5.9   (72%)" ]]
    [[ "${lines[1]}" == "memory  2.4G / 20G   (11%)" ]]
}

@test "cluster-big> kubectl view-utilization masters" {

    switch_context cluster-big
    run /code/kubectl-view-utilization -l node-role.kubernetes.io/master=true
    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "cores    8.7 / 16    (54%)" ]]
    [[ "${lines[1]}" == "memory  6.4G / 60G   (10%)" ]]
}
