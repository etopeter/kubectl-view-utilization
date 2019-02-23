#!/usr/bin/env bats
set -a

load helper_functions
load mocks/kubectl

@test "[k1] cluster-small> kubectl get nodes allocatable cpu and memory" {

    switch_context cluster-small

    run kubectl get nodes -o=jsonpath="{range .items[*]}{.metadata.name}{'\t'}{.status.allocatable.cpu}{'\t'}{.status.allocatable.memory}{'\n'}{end}"

    [ $status -eq 0 ]
    [[ "${lines[0]}" == "ip-10-1-1-10.us-west-2.compute.internal	449m	1351126Ki" ]]
    [[ "${lines[1]}" == "ip-10-1-1-11.us-west-2.compute.internal	449m	1351126Ki" ]]
}

@test "[k2] cluster-medium> kubectl get nodes allocatable cpu and memory" {

    switch_context cluster-medium

    run kubectl get nodes -o=jsonpath="{range .items[*]}{.metadata.name}{'\t'}{.status.allocatable.cpu}{'\t'}{.status.allocatable.memory}{'\n'}{end}"

    [ $status -eq 0 ]
    [[ "${lines[0]}" == "ip-10-1-1-10.us-west-2.compute.internal	940m	2702252Ki" ]]
    [[ "${lines[3]}" == "ip-10-1-1-14.us-west-2.compute.internal	8	31700424Ki" ]]
}

@test "[k3] cluster-big> kubectl get nodes allocatable cpu and memory" {

    switch_context cluster-big

    run kubectl get nodes -o=jsonpath="{range .items[*]}{.metadata.name}{'\t'}{.status.allocatable.cpu}{'\t'}{.status.allocatable.memory}{'\n'}{end}"

    [ $status -eq 0 ]
    [[ "${lines[2]}" == "ip-10-1-1-14.us-west-2.compute.internal	4	15850212Ki" ]]
    [[ "${lines[6]}" == "ip-10-1-1-18.us-west-2.compute.internal	16	63400848Ki" ]]
    [[ "${lines[26]}" == "ip-10-1-1-38.us-west-2.compute.internal	32	63400848Ki" ]]
}

@test "[k4] cluster-small> kubectl get pod requests cpu and memory" {

    switch_context cluster-small

    run kubectl get pod --all-namespaces --field-selector=status.phase=Running -o=go-template -o=jsonpath="{{/* get_pod_data */}}"

    [ $status -eq 0 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "default	ip-10-1-1-10.us-west-2.compute.internal	10m	0Ki	100m	50Ki" ]]
    [[ "${lines[1]}" == "default	ip-10-1-1-11.us-west-2.compute.internal	0	0Ki	100m	50Ki" ]]
    [[ "${lines[2]}" == "default	ip-10-1-1-10.us-west-2.compute.internal	50m	300Mi	100m	500Mi" ]]
}

@test "[k5] cluster-medium> kubectl get pod requests cpu and memory" {

    switch_context cluster-medium

    run kubectl get pod --all-namespaces --field-selector=status.phase=Running -o=go-template -o=jsonpath="{{/* get_pod_data */}}"

    [ $status -eq 0 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "kube-system	ip-10-1-1-10.us-west-2.compute.internal	10m	0Ki	0	0Ki" ]]
}

@test "[k6] cluster-big> kubectl get pod requests cpu and memory" {

    switch_context cluster-big

    run kubectl get pod --all-namespaces --field-selector=status.phase=Running -o=go-template -o=jsonpath="{{/* get_pod_data */}}"

    [ $status -eq 0 ]
    echo "output = ${output}"
    echo "it should be: ${lines[14]}"
    [[ "${lines[0]}" == "default	ip-10-1-1-10.us-west-2.compute.internal	10m	0Ki	0	0Ki" ]]
    [[ "${lines[7]}" == "kube-system	ip-10-1-1-15.us-west-2.compute.internal	5m	32Mi	0	0Ki" ]]
    [[ "${lines[14]}" == "qa	ip-10-1-1-15.us-west-2.compute.internal	2	1G	0	0Ki" ]]
}
