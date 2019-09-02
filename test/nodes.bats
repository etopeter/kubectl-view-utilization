#!/usr/bin/env bats
set -a

load helper_functions
load mocks/kubectl

@test "[no1] cluster-small (gawk)> kubectl view utilization nodes" {

    use_awk gawk 
    switch_context cluster-small

    run /code/kubectl-view-utilization nodes

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[3]}" == "Node                                     Requests  %Requests  Limits  %Limits   Requests  %Requests     Limits  %Limits" ]]
    [[ "${lines[4]}" == "ip-10-1-1-10.us-west-2.compute.internal        60         13     200       44  314572800         22  524339200       37" ]]
    [[ "${lines[5]}" == "ip-10-1-1-11.us-west-2.compute.internal        10          2     140       31   67108864          4  134268928        9" ]]
}

@test "[no2] cluster-small (gawk)> kubectl view utilization nodes no headers" {

    use_awk gawk 
    switch_context cluster-small

    run /code/kubectl-view-utilization nodes --no-headers

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "ip-10-1-1-10.us-west-2.compute.internal        60         13     200       44  314572800         22  524339200       37" ]]
    [[ "${lines[1]}" == "ip-10-1-1-11.us-west-2.compute.internal        10          2     140       31   67108864          4  134268928        9" ]]
}

@test "[no3] cluster-medium (mawk)> kubectl view utilization nodes " {

    use_awk mawk 
    switch_context cluster-medium

    run /code/kubectl-view-utilization nodes

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[4]}" == "ip-10-1-1-10.us-west-2.compute.internal        70          7       0        0   314572800         11       0        0" ]]
    [[ "${lines[5]}" == "ip-10-1-1-11.us-west-2.compute.internal      4210        447       0        0  2220883968         80       0        0" ]]
    [[ "${lines[6]}" == "ip-10-1-1-12.us-west-2.compute.internal         0          0       0        0           0          0       0        0" ]]
    [[ "${lines[7]}" == "ip-10-1-1-14.us-west-2.compute.internal      3010         37       0        0  2214592512          6       0        0" ]]
    [[ "${lines[8]}" == "ip-10-1-1-15.us-west-2.compute.internal      8500        106       0        0  5637144576         17       0        0" ]]
    [[ "${lines[9]}" == "ip-10-1-1-16.us-west-2.compute.internal      5010         62       0        0  3221225472          9       0        0" ]]
}

@test "[no4] cluster-big (mawk)> kubectl view utilization nodes " {

    use_awk mawk 
    switch_context cluster-big

    run /code/kubectl-view-utilization nodes

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[4]}" == "ip-10-1-1-11.us-west-2.compute.internal        10          1       0        0           0          0       0        0" ]]
    [[ "${lines[5]}" == "ip-10-1-1-12.us-west-2.compute.internal        60          6       0        0   314572800         11       0        0" ]]
    [[ "${lines[6]}" == "ip-10-1-1-14.us-west-2.compute.internal      2100         52       0        0  1147142144          7       0        0" ]]
    [[ "${lines[7]}" == "ip-10-1-1-18.us-west-2.compute.internal      2000         12       0        0  4294967296          6       0        0" ]]
    [[ "${lines[8]}" == "ip-10-1-1-19.us-west-2.compute.internal      2000         12       0        0  4294967296          6       0        0" ]]
    [[ "${lines[9]}" == "ip-10-1-1-20.us-west-2.compute.internal      3000         18       0        0  5368709120          8       0        0" ]]
    [[ "${lines[10]}" == "ip-10-1-1-21.us-west-2.compute.internal      3000         18       0        0  5368709120          8       0        0" ]]
    [[ "${lines[11]}" == "ip-10-1-1-22.us-west-2.compute.internal      3000         18       0        0  7516192768         11       0        0" ]]
    [[ "${lines[13]}" == "ip-10-1-1-24.us-west-2.compute.internal      2000         12       0        0  8589934592         13       0        0" ]]
    [[ "${lines[14]}" == "ip-10-1-1-25.us-west-2.compute.internal      2000         12       0        0  8589934592         13       0        0" ]]
    [[ "${lines[15]}" == "ip-10-1-1-26.us-west-2.compute.internal      2000         12       0        0  8589934592         13       0        0" ]]
  
   
}
