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
    echo "output = ${output}"
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
    run kubectl get nodes -o=jsonpath="{range .items[*]}{.status.allocatable.cpu}{'\t'}{.status.allocatable.memory}{'\n'}{end}"
    [ $status -eq 0 ]
    [[ "${lines[0]}" == "449m	1351126Ki" ]]
    [[ "${lines[1]}" == "449m	1351126Ki" ]]
}

@test "cluster-medium> kubectl get nodes allocatable cpu and memory" {

    switch_context cluster-medium
    run kubectl get nodes -o=jsonpath="{range .items[*]}{.status.allocatable.cpu}{'\t'}{.status.allocatable.memory}{'\n'}{end}"
    [ $status -eq 0 ]
    [[ "${lines[0]}" == "940m	2702252Ki" ]]
    [[ "${lines[3]}" == "8      31700424Ki" ]]
}

@test "cluster-big> kubectl get nodes allocatable cpu and memory" {

    switch_context cluster-big
    run kubectl get nodes -o=jsonpath="{range .items[*]}{.status.allocatable.cpu}{'\t'}{.status.allocatable.memory}{'\n'}{end}"
    [ $status -eq 0 ]
    [[ "${lines[2]}" == "4      15850212Ki" ]]
    [[ "${lines[6]}" == "16     63400848Ki" ]]
    [[ "${lines[26]}" == "32     63400848Ki" ]]

}

@test "cluster-small> kubectl get pod requests cpu and memory" {

    switch_context cluster-small
    run kubectl get pod --all-namespaces -o=jsonpath="{range .items[*]}{range .spec.containers[*]}{.resources.requests.cpu}{'\t'}{.resources.requests.memory}{'\n'}{end}{'\n'}{end}"
    [ $status -eq 0 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "10m" ]]
    [[ "${lines[1]}" == "50m   300Mi" ]]
    [[ "${lines[2]}" == "5m    32Mi" ]]
}

@test "cluster-medium> kubectl get pod requests cpu and memory" {

    switch_context cluster-medium
    run kubectl get pod --all-namespaces -o=jsonpath="{range .items[*]}{range .spec.containers[*]}{.resources.requests.cpu}{'\t'}{.resources.requests.memory}{'\n'}{end}{'\n'}{end}"
    [ $status -eq 0 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "10m" ]]
}

@test "cluster-big> kubectl get pod requests cpu and memory" {

    switch_context cluster-big
    run kubectl get pod --all-namespaces -o=jsonpath="{range .items[*]}{range .spec.containers[*]}{.resources.requests.cpu}{'\t'}{.resources.requests.memory}{'\n'}{end}{'\n'}{end}"
    [ $status -eq 0 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "10m" ]]
    [[ "${lines[7]}" == "2    1G" ]]
    [[ "${lines[14]}" == "2    3G" ]]
}

@test "cluster-small> kubectl view utilization" {

    switch_context cluster-small
    run /code/kubectl-view-utilization
    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "cores     0.07 / 0.9     (7%)" ]]
    [[ "${lines[1]}" == "memory   364Mb / 2.6GiB  (13%)" ]]
}

@test "cluster-medium> kubectl view utilization" {

    switch_context cluster-medium
    run /code/kubectl-view-utilization
    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "cores       21 / 30      (70%)" ]]
    [[ "${lines[1]}" == "memory   13GiB / 111GiB  (11%)" ]]
}

@test "cluster-big> kubectl view utilization" {

    switch_context cluster-big
    run /code/kubectl-view-utilization
    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "cores       99 / 538     (18%)" ]]
    [[ "${lines[1]}" == "memory  144GiB / 1.6TiB  (8%)" ]]
}
