#!/usr/bin/env bats
set -a

load helper_functions
load mocks/kubectl

@test "[ns1] cluster-small (gawk)> kubectl view-utilization namespaces" {

    use_awk gawk
    switch_context cluster-small

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "NAMESPACE       CPU Requests     CPU Limits     Memory Requests     Memory Limits" ]]
    [[ "${lines[2]}" == "kube-system             0.01           0.04                 64M              128M" ]]
}

@test "[ns2] cluster-small (gawk)> kubectl view-utilization namespaces -o json" {

    use_awk gawk
    switch_context cluster-small

    run /code/kubectl-view-utilization namespaces -o json

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == '{"default": {"CPU": {"requested": 60,"limits": 300},"Memory": {"requested": 314572800,"limits": 524390400}},"kube-system": {"CPU": {"requested": 10,"limits": 40},"Memory": {"requested": 67108864,"limits": 134217728}}}' ]]
}

@test "[ns3] cluster-small (mawk)> kubectl view-utilization namespaces" {

    use_awk mawk
    switch_context cluster-small

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "NAMESPACE       CPU Requests     CPU Limits     Memory Requests     Memory Limits" ]]
    [[ "${lines[2]}" == "kube-system             0.01           0.04                 64M              128M" ]]
}

@test "[ns4] cluster-small (original-awk)> kubectl view-utilization namespaces" {

    use_awk original-awk
    switch_context cluster-small

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "NAMESPACE       CPU Requests     CPU Limits     Memory Requests     Memory Limits" ]]
    [[ "${lines[2]}" == "kube-system             0.01           0.04                 64M              128M" ]]
}

@test "[ns5] cluster-medium (gawk)> kubectl view-utilization namespaces" {

    use_awk gawk
    switch_context cluster-medium

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "NAMESPACE       CPU Requests     CPU Limits     Memory Requests     Memory Limits" ]]
    [[ "${lines[1]}" == "default                  2.3              0                1.4G                 0" ]]
    [[ "${lines[3]}" == "qa                        18              0                 11G                 0" ]]
}

@test "[ns6] cluster-medium (mawk)> kubectl view-utilization namespaces" {

    use_awk mawk
    switch_context cluster-medium

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "NAMESPACE       CPU Requests     CPU Limits     Memory Requests     Memory Limits" ]]
    [[ "${lines[1]}" == "default                  2.3              0                1.4G                 0" ]]
    [[ "${lines[3]}" == "qa                        18              0                 11G                 0" ]]
}

@test "[ns7] cluster-medium (original-awk)> kubectl view-utilization namespaces" {

    use_awk original-awk
    switch_context cluster-medium

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "NAMESPACE       CPU Requests     CPU Limits     Memory Requests     Memory Limits" ]]
    [[ "${lines[1]}" == "default                  2.3              0                1.4G                 0" ]]
    [[ "${lines[3]}" == "qa                        18              0                 11G                 0" ]]
}

@test "[ns8] cluster-big (gawk)> kubectl view-utilization namespaces" {

    use_awk gawk
    switch_context cluster-big

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "NAMESPACE       CPU Requests     CPU Limits     Memory Requests     Memory Limits" ]]
    [[ "${lines[1]}" == "default                 0.02              0                   0                 0" ]]
    [[ "${lines[3]}" == "kube-system             0.27              0                434M                 0" ]]
    [[ "${lines[6]}" == "stg                       30              0                 60G                 0" ]]
}

@test "[ns9] cluster-big (mawk)> kubectl view-utilization namespaces" {

    use_awk mawk
    switch_context cluster-big

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "NAMESPACE       CPU Requests     CPU Limits     Memory Requests     Memory Limits" ]]
    [[ "${lines[1]}" == "default                 0.02              0                   0                 0" ]]
    [[ "${lines[3]}" == "kube-system             0.27              0                434M                 0" ]]
    [[ "${lines[6]}" == "stg                       30              0                 60G                 0" ]]
}

@test "[ns10] cluster-big (original-awk)> kubectl view-utilization namespaces" {

    use_awk original-awk
    switch_context cluster-big

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "NAMESPACE       CPU Requests     CPU Limits     Memory Requests     Memory Limits" ]]
    [[ "${lines[1]}" == "default                 0.02              0                   0                 0" ]]
    [[ "${lines[3]}" == "kube-system             0.27              0                434M                 0" ]]
    [[ "${lines[6]}" == "stg                       30              0                 60G                 0" ]]
}

@test "[ns11] cluster-bug1 (original-awk)> kubectl view-utilization namespaces" {

    use_awk original-awk
    switch_context cluster-bug1

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "NAMESPACE     CPU Requests     CPU Limits     Memory Requests     Memory Limits" ]]
    [[ "${lines[1]}" == "infra                    0              0                3.4G                 0" ]]
}

@test "[ns12] cluster-bug1 (gawk)> kubectl view-utilization namespaces" {

    use_awk gawk
    switch_context cluster-bug1

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "NAMESPACE     CPU Requests     CPU Limits     Memory Requests     Memory Limits" ]]
    [[ "${lines[1]}" == "infra                    0              0                3.4G                 0" ]]
}

@test "[ns13] cluster-bug1 (mawk)> kubectl view-utilization namespaces" {

    use_awk mawk
    switch_context cluster-bug1

    run /code/kubectl-view-utilization namespaces

    echo "${output}"
    [ $status -eq 0 ]
    [[ "${lines[0]}" == "NAMESPACE     CPU Requests     CPU Limits     Memory Requests     Memory Limits" ]]
    [[ "${lines[1]}" == "infra                    0              0                3.4G                 0" ]]
}
