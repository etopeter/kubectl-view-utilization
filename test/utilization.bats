#!/usr/bin/env bats
set -a
BATS_VERSION=0.4.0

setup() {
    load /code/test/mocks/kubectl
}

teardown() {
    echo "Tests complete"
}

@test "kubectl get nodes allocatable cpu and memory" {

    run kubectl get nodes -o=jsonpath="{range .items[*]} {.status.allocatable.cpu}{'\t'}{.status.allocatable.memory}{'\n'}{end}"
    [ $status -eq 0 ]
    [[ "${lines[0]}" == " 940m	2702252Ki" ]]
    [[ "${lines[3]}" == " 4      15850212Ki" ]]
}

@test "kubectl get pod requests cpu and memory" {

    run kubectl get pod --all-namespaces -o=jsonpath="{range .items[*]}{range .spec.containers[*]}  {.resources.requests.cpu}{'\t'}{.resources.requests.memory}{'\n'}{end}{'\n'}{end}"
    [ $status -eq 0 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "  10m" ]]
}


@test "kubectl utilization -v" {

    run /code/kubectl-utilization -v
    [ $status -eq 0 ]
    echo "output = ${output}"
    [[ "$output" == v* ]]
}

@test "kubectl utilization" {

    run /code/kubectl-utilization
    [ $status -eq 0 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "cores: 3.3/15 cores (22%)" ]]
    [[ "${lines[1]}" == "memory: 1.92 GiB/53.08 GiB (3%)" ]]
}


