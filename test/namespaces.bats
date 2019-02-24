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
    [[ "${lines[0]}" == "Namespace    CPU Requests  CPU Limits  Memory Requests  Memory Limits" ]]
    [[ "${lines[1]}" == "default                60         300        314572800      524390400" ]]
    [[ "${lines[2]}" == "kube-system            10          40         67108864      134217728" ]]
}

@test "[ns2] cluster-small (gawk)> kubectl view-utilization namespaces -h" {

    use_awk gawk
    switch_context cluster-small

    run /code/kubectl-view-utilization namespaces -h

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[1]}" == "Namespace     Req   Lim   Req   Lim" ]]
    [[ "${lines[2]}" == "default      0.06   0.3  300M  500M" ]]
    [[ "${lines[3]}" == "kube-system  0.01  0.04   64M  128M" ]]
}

@test "[ns3] cluster-small (gawk)> kubectl view-utilization namespaces -o json" {

    use_awk gawk
    switch_context cluster-small

    run /code/kubectl-view-utilization namespaces -o json

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == '{"default": {"CPU": {"requested": 60,"limits": 300},"Memory": {"requested": 314572800,"limits": 524390400}},"kube-system": {"CPU": {"requested": 10,"limits": 40},"Memory": {"requested": 67108864,"limits": 134217728}}}' ]]
}

@test "[ns4] cluster-small (mawk)> kubectl view-utilization namespaces" {

    use_awk mawk
    switch_context cluster-small

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Namespace    CPU Requests  CPU Limits  Memory Requests  Memory Limits" ]]
    [[ "${lines[1]}" == "default                60         300        314572800      524390400" ]]
    [[ "${lines[2]}" == "kube-system            10          40         67108864      134217728" ]]
}

@test "[ns5] cluster-small (original-awk)> kubectl view-utilization namespaces" {

    use_awk original-awk
    switch_context cluster-small

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Namespace    CPU Requests  CPU Limits  Memory Requests  Memory Limits" ]]
    [[ "${lines[1]}" == "default                60         300        314572800      524390400" ]]
    [[ "${lines[2]}" == "kube-system            10          40         67108864      134217728" ]]
}

@test "[ns6] cluster-medium (gawk)> kubectl view-utilization namespaces" {

    use_awk gawk
    switch_context cluster-medium

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Namespace    CPU Requests  CPU Limits  Memory Requests  Memory Limits" ]]
    [[ "${lines[1]}" == "default              2262           0       1528823808              0" ]]
    [[ "${lines[3]}" == "qa                  18018           0      11811160064              0" ]]
}

@test "[ns7] cluster-medium (gawk)> kubectl view-utilization namespaces -h" {

    use_awk gawk
    switch_context cluster-medium

    run /code/kubectl-view-utilization namespaces -h

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[1]}" == "Namespace    Req  Lim   Req  Lim" ]]
    [[ "${lines[2]}" == "default      2.3    0  1.4G    0" ]]
    [[ "${lines[4]}" == "qa            18    0   11G    0" ]]
}

@test "[ns8] cluster-medium (mawk)> kubectl view-utilization namespaces" {

    use_awk mawk
    switch_context cluster-medium

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Namespace    CPU Requests  CPU Limits  Memory Requests  Memory Limits" ]]
    [[ "${lines[1]}" == "default              2262           0       1528823808              0" ]]
    [[ "${lines[3]}" == "qa                  18018           0      11811160064              0" ]]
}

@test "[ns9] cluster-medium (original-awk)> kubectl view-utilization namespaces" {

    use_awk original-awk
    switch_context cluster-medium

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Namespace    CPU Requests  CPU Limits  Memory Requests  Memory Limits" ]]
    [[ "${lines[1]}" == "default              2262           0       1528823808              0" ]]
    [[ "${lines[3]}" == "qa                  18018           0      11811160064              0" ]]
}

@test "[ns10] cluster-big (gawk)> kubectl view-utilization namespaces" {

    use_awk gawk
    switch_context cluster-big

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Namespace    CPU Requests  CPU Limits  Memory Requests  Memory Limits" ]]
    [[ "${lines[1]}" == "default                20           0                0              0" ]]
    [[ "${lines[3]}" == "kube-system           270           0        455081984              0" ]]
    [[ "${lines[5]}" == "qa                  42042           0      56908316672              0" ]]
    [[ "${lines[6]}" == "stg                 30030           0      64424509440              0" ]]
}

@test "[ns11] cluster-big (mawk)> kubectl view-utilization namespaces" {

    use_awk mawk
    switch_context cluster-big

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Namespace    CPU Requests  CPU Limits  Memory Requests  Memory Limits" ]]
    [[ "${lines[1]}" == "default                20           0                0              0" ]]
    [[ "${lines[3]}" == "kube-system           270           0        455081984              0" ]]
    [[ "${lines[5]}" == "qa                  42042           0      56908316672              0" ]]
    [[ "${lines[6]}" == "stg                 30030           0      64424509440              0" ]]
}

@test "[ns12] cluster-big (original-awk)> kubectl view-utilization namespaces" {

    use_awk original-awk
    switch_context cluster-big

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Namespace    CPU Requests  CPU Limits  Memory Requests  Memory Limits" ]]
    [[ "${lines[1]}" == "default                20           0                0              0" ]]
    [[ "${lines[3]}" == "kube-system           270           0        455081984              0" ]]
    [[ "${lines[5]}" == "qa                  42042           0      56908316672              0" ]]
    [[ "${lines[6]}" == "stg                 30030           0      64424509440              0" ]]
}

@test "[ns13] cluster-bug1 (original-awk)> kubectl view-utilization namespaces" {

    use_awk original-awk
    switch_context cluster-bug1

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Namespace  CPU Requests  CPU Limits  Memory Requests  Memory Limits" ]]
    [[ "${lines[1]}" == "infra                 0           0       3606605824              0" ]]
}

@test "[ns14] cluster-bug1 (gawk)> kubectl view-utilization namespaces" {

    use_awk gawk
    switch_context cluster-bug1

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Namespace  CPU Requests  CPU Limits  Memory Requests  Memory Limits" ]]
    [[ "${lines[1]}" == "infra                 0           0       3606605824              0" ]]
}

@test "[ns15] cluster-bug1 (mawk)> kubectl view-utilization namespaces" {

    use_awk mawk
    switch_context cluster-bug1

    run /code/kubectl-view-utilization namespaces

    echo "${output}"
    [ $status -eq 0 ]
    [[ "${lines[0]}" == "Namespace  CPU Requests  CPU Limits  Memory Requests  Memory Limits" ]]
    [[ "${lines[1]}" == "infra                 0           0       3606605824              0" ]]
}
