#!/usr/bin/env bats
set -a

@test "kubectl view utilization -v" {

    run /code/kubectl-view-utilization -v
    [ $status -eq 0 ]
    echo "output = ${output}"
    [[ "$output" == v* ]]
}

@test "kubectl view utilization -h" {

    run /code/kubectl-view-utilization -h
    [ $status -eq 0 ]
    echo "output = ${output}"
    [[ "${lines[1]}" == "-n[--namespace]     filter by namespace" ]]
    [[ "${lines[4]}" == "-h                  prints help" ]]
}

@test "kubectl view utilization -o unknown" {

    run /code/kubectl-view-utilization -o unknown
    [ $status -eq 1 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "valid values are text, json" ]]
}

@test "kubectl view utilization --output unknown" {

    run /code/kubectl-view-utilization --output unknown
    [ $status -eq 1 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "valid values are text, json" ]]
}

@test "kubectl view utilization namespaces -o unknown" {

    run /code/kubectl-view-utilization namespaces -o unknown
    [ $status -eq 1 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "valid values are text, json" ]]
}


@test "kubectl view utilization namespaces --output unknown" {

    run /code/kubectl-view-utilization namespaces --output unknown
    [ $status -eq 1 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "valid values are text, json" ]]
}

