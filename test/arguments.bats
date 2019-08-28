#!/usr/bin/env bats
set -a

@test "[a1] kubectl view utilization -v" {

    run /code/kubectl-view-utilization -v
    [ $status -eq 0 ]
    echo "output = ${output}"
    [[ "$output" == v* ]]
}

@test "[a2] kubectl view utilization --help" {

    run /code/kubectl-view-utilization --help
    [ $status -eq 0 ]
    echo "output = ${output}"
    [[ "${lines[1]}" == "-n[--namespace]     Filter by namespace" ]]
    [[ "${lines[4]}" == "-h                  Human readable" ]]
    [[ "${lines[7]}" == "--help              Prints help" ]]
}

@test "[a3] kubectl view utilization --unknown" {

    run /code/kubectl-view-utilization --unknown
    [ $status -eq 1 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "Unknown option: --unknown" ]]
}

@test "[a4] kubectl view utilization -o unknown" {

    run /code/kubectl-view-utilization -o unknown
    [ $status -eq 1 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "Output value is required. Valid values are: text, json." ]]
}

@test "[a5] kubectl view utilization --output unknown" {

    run /code/kubectl-view-utilization --output unknown
    [ $status -eq 1 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "Output value is required. Valid values are: text, json." ]]
}

@test "[a6] kubectl view utilization --output=unknown" {

    run /code/kubectl-view-utilization --output=unknown
    [ $status -eq 1 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "Output value is required. Valid values are: text, json." ]]
}

@test "[a7] kubectl view utilization -l" {

    run /code/kubectl-view-utilization -l
    [ $status -eq 1 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "Label selector value is required" ]]
}

@test "[a8] kubectl view utilization --selector" {

    run /code/kubectl-view-utilization --selector
    [ $status -eq 1 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "Label selector value is required" ]]
}

@test "[a9] kubectl view utilization --selector=" {

    run /code/kubectl-view-utilization --selector=
    [ $status -eq 1 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "Label selector value is required" ]]
}

@test "[a10] kubectl view utilization namespaces -o" {

    run /code/kubectl-view-utilization namespaces -o
    [ $status -eq 1 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "Output value is required. Valid values are: text, json." ]]
}

@test "[a11] kubectl view utilization namespaces -o unknown" {

    run /code/kubectl-view-utilization namespaces -o unknown
    [ $status -eq 1 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "Output value is required. Valid values are: text, json." ]]
}


@test "[a12] kubectl view utilization namespaces --output unknown" {

    run /code/kubectl-view-utilization namespaces --output unknown
    [ $status -eq 1 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "Output value is required. Valid values are: text, json." ]]
}

@test "[a13] kubectl view utilization namespaces --output=" {

    run /code/kubectl-view-utilization namespaces --output=
    [ $status -eq 1 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "Output value is required. Valid values are: text, json." ]]
}

@test "[a14] kubectl view utilization -n" {

    run /code/kubectl-view-utilization -n
    [ $status -eq 1 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "Namespace name is required" ]]
}

@test "[a15] kubectl view utilization --namespace" {

    run /code/kubectl-view-utilization --namespace
    [ $status -eq 1 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "Namespace name is required" ]]
}

@test "[a16] kubectl view utilization --namespace=" {

    run /code/kubectl-view-utilization --namespace=
    [ $status -eq 1 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "Namespace name is required" ]]
}
