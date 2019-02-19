#!/usr/bin/env bats
set -a

load helper_functions
load mocks/kubectl

@test "cluster-small> kubectl get nodes allocatable cpu and memory" {

    switch_context cluster-small

    run kubectl get nodes -o=jsonpath="{range .items[*]}{.metadata.name}{'\t'}{.status.allocatable.cpu}{'\t'}{.status.allocatable.memory}{'\n'}{end}"

    [ $status -eq 0 ]
    [[ "${lines[0]}" == "ip-10-1-1-10.us-west-2.compute.internal	449m	1351126Ki" ]]
    [[ "${lines[1]}" == "ip-10-1-1-11.us-west-2.compute.internal	449m	1351126Ki" ]]
}

@test "cluster-small> kubectl get pod requests cpu and memory" {

    switch_context cluster-small

    run kubectl get pod --all-namespaces --field-selector=status.phase=Running -o=go-template -o=jsonpath="{{/* get_pod_data */}}"

    [ $status -eq 0 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "default	ip-10-1-1-10.us-west-2.compute.internal	10m	0Ki	100m	50Ki" ]]
    [[ "${lines[1]}" == "default	ip-10-1-1-11.us-west-2.compute.internal	0	0Ki	100m	50Ki" ]]
    [[ "${lines[2]}" == "default	ip-10-1-1-10.us-west-2.compute.internal	50m	300Mi	100m	500Mi" ]]
}

@test "cluster-small (gawk)> kubectl view utilization -o text" {

    use_awk gawk 
    switch_context cluster-small

    run /code/kubectl-view-utilization -o text

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Req  %Req   Lim  %Lim  Alloc  Free" ]]
    [[ "${lines[1]}" == "CPU       0.07    7%  0.34   37%    0.9  0.83" ]]
    [[ "${lines[2]}" == "Memory    364M   13%  628M   23%   2.6G  2.2G" ]]
}

@test "cluster-small (gawk)> kubectl view utilization -o json" {

    use_awk gawk 
    switch_context cluster-small

    run /code/kubectl-view-utilization -o json

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == '{"CPU": {"requested": 70,"limits": 340,"allocatable": 898,"utilization": 7},"Memory": {"requested": 381681664,"limits": 658608128,"allocatable": 2767106048,"utilization": 13}}' ]]
}

@test "cluster-small (gawk)> kubectl view-utilization namespaces" {

    use_awk gawk
    switch_context cluster-small

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "NAMESPACE       CPU Requests     CPU Limits     Memory Requests     Memory Limits" ]]
    [[ "${lines[2]}" == "kube-system             0.01           0.04                 64M              128M" ]]
}

@test "cluster-small (gawk)> kubectl view-utilization namespaces -o json" {

    use_awk gawk
    switch_context cluster-small

    run /code/kubectl-view-utilization namespaces -o json

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == '{"default": {"CPU": {"requested": 60,"limits": 300},"Memory": {"requested": 314572800,"limits": 524390400}},"kube-system": {"CPU": {"requested": 10,"limits": 40},"Memory": {"requested": 67108864,"limits": 134217728}}}' ]]
}

@test "cluster-small (mawk)> kubectl view-utilization namespaces" {

    use_awk mawk
    switch_context cluster-small

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "NAMESPACE       CPU Requests     CPU Limits     Memory Requests     Memory Limits" ]]
    [[ "${lines[2]}" == "kube-system             0.01           0.04                 64M              128M" ]]
}

@test "cluster-small (original-awk)> kubectl view-utilization namespaces" {

    use_awk original-awk
    switch_context cluster-small

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "NAMESPACE       CPU Requests     CPU Limits     Memory Requests     Memory Limits" ]]
    [[ "${lines[2]}" == "kube-system             0.01           0.04                 64M              128M" ]]
}

@test "cluster-small (gawk)> kubectl view-utilization masters" {

    use_awk gawk
    switch_context cluster-small

    run /code/kubectl-view-utilization --selector=node-role.kubernetes.io/master=true

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Req  %Req   Lim  %Lim  Alloc  Free" ]]
    [[ "${lines[1]}" == "CPU       0.06   13%   0.2   44%   0.45  0.39" ]]
    [[ "${lines[2]}" == "Memory    300M   22%  500M   37%   1.3G  1019M" ]]
}

@test "cluster-medium> kubectl get nodes allocatable cpu and memory" {

    switch_context cluster-medium

    run kubectl get nodes -o=jsonpath="{range .items[*]}{.metadata.name}{'\t'}{.status.allocatable.cpu}{'\t'}{.status.allocatable.memory}{'\n'}{end}"

    [ $status -eq 0 ]
    [[ "${lines[0]}" == "ip-10-1-1-10.us-west-2.compute.internal	940m	2702252Ki" ]]
    [[ "${lines[3]}" == "ip-10-1-1-14.us-west-2.compute.internal	8	31700424Ki" ]]
}

@test "cluster-medium> kubectl get pod requests cpu and memory" {

    switch_context cluster-medium

    run kubectl get pod --all-namespaces --field-selector=status.phase=Running -o=go-template -o=jsonpath="{{/* get_pod_data */}}"

    [ $status -eq 0 ]
    echo "output = ${output}"
    [[ "${lines[0]}" == "kube-system	ip-10-1-1-10.us-west-2.compute.internal	10m	0Ki	0	0Ki" ]]
}

@test "cluster-medium (gawk)> kubectl view utilization --output=text" {

    use_awk gawk 
    switch_context cluster-medium

    run /code/kubectl-view-utilization --output=text

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Req  %Req   Lim  %Lim  Alloc  Free" ]]
    [[ "${lines[1]}" == "CPU         20   69%     0    0%     29   9.1" ]]
    [[ "${lines[2]}" == "Memory     13G   11%     0    0%   111G   98G" ]]
}

@test "cluster-medium (mawk)> kubectl view utilization --output text" {

    use_awk mawk
    switch_context cluster-medium --output text

    run /code/kubectl-view-utilization

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Req  %Req   Lim  %Lim  Alloc  Free" ]]
    [[ "${lines[1]}" == "CPU         20   69%     0    0%     29   9.1" ]]
    [[ "${lines[2]}" == "Memory     13G   11%     0    0%   111G   98G" ]]
}

@test "cluster-medium (mawk)> kubectl view utilization" {

    use_awk mawk
    switch_context cluster-medium

    run /code/kubectl-view-utilization

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Req  %Req   Lim  %Lim  Alloc  Free" ]]
    [[ "${lines[1]}" == "CPU         20   69%     0    0%     29   9.1" ]]
    [[ "${lines[2]}" == "Memory     13G   11%     0    0%   111G   98G" ]]
}

@test "cluster-medium (original-awk)> kubectl view utilization" {

    use_awk original-awk
    switch_context cluster-medium

    run /code/kubectl-view-utilization

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Req  %Req   Lim  %Lim  Alloc  Free" ]]
    [[ "${lines[1]}" == "CPU         20   69%     0    0%     29   9.1" ]]
    [[ "${lines[2]}" == "Memory     13G   11%     0    0%   111G   98G" ]]
}

@test "cluster-medium (gawk)> kubectl view-utilization namespaces" {

    use_awk gawk
    switch_context cluster-medium

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "NAMESPACE       CPU Requests     CPU Limits     Memory Requests     Memory Limits" ]]
    [[ "${lines[1]}" == "default                  2.3              0                1.4G                 0" ]]
    [[ "${lines[3]}" == "qa                        18              0                 11G                 0" ]]
}

@test "cluster-medium (mawk)> kubectl view-utilization namespaces" {

    use_awk mawk
    switch_context cluster-medium

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "NAMESPACE       CPU Requests     CPU Limits     Memory Requests     Memory Limits" ]]
    [[ "${lines[1]}" == "default                  2.3              0                1.4G                 0" ]]
    [[ "${lines[3]}" == "qa                        18              0                 11G                 0" ]]
}

@test "cluster-medium (original-awk)> kubectl view-utilization namespaces" {

    use_awk original-awk
    switch_context cluster-medium

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "NAMESPACE       CPU Requests     CPU Limits     Memory Requests     Memory Limits" ]]
    [[ "${lines[1]}" == "default                  2.3              0                1.4G                 0" ]]
    [[ "${lines[3]}" == "qa                        18              0                 11G                 0" ]]
}

@test "cluster-medium (gawk)> kubectl view-utilization masters" {

    use_awk gawk
    switch_context cluster-medium

    run /code/kubectl-view-utilization --selector node-role.kubernetes.io/master=true

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Req  %Req   Lim  %Lim  Alloc  Free" ]]
    [[ "${lines[1]}" == "CPU        4.3   72%     0    0%    5.9   1.6" ]]
    [[ "${lines[2]}" == "Memory    2.4G   11%     0    0%    20G   18G" ]]
}


@test "cluster-big> kubectl get nodes allocatable cpu and memory" {

    switch_context cluster-big

    run kubectl get nodes -o=jsonpath="{range .items[*]}{.metadata.name}{'\t'}{.status.allocatable.cpu}{'\t'}{.status.allocatable.memory}{'\n'}{end}"

    [ $status -eq 0 ]
    [[ "${lines[2]}" == "ip-10-1-1-14.us-west-2.compute.internal	4	15850212Ki" ]]
    [[ "${lines[6]}" == "ip-10-1-1-18.us-west-2.compute.internal	16	63400848Ki" ]]
    [[ "${lines[26]}" == "ip-10-1-1-38.us-west-2.compute.internal	32	63400848Ki" ]]
}

@test "cluster-big> kubectl get pod requests cpu and memory" {

    switch_context cluster-big

    run kubectl get pod --all-namespaces --field-selector=status.phase=Running -o=go-template -o=jsonpath="{{/* get_pod_data */}}"

    [ $status -eq 0 ]
    echo "output = ${output}"
    echo "it should be: ${lines[14]}"
    [[ "${lines[0]}" == "default	ip-10-1-1-10.us-west-2.compute.internal	10m	0Ki	0	0Ki" ]]
    [[ "${lines[7]}" == "kube-system	ip-10-1-1-15.us-west-2.compute.internal	5m	32Mi	0	0Ki" ]]
    [[ "${lines[14]}" == "qa	ip-10-1-1-15.us-west-2.compute.internal	2	1G	0	0Ki" ]]
}

@test "cluster-big (gawk)> kubectl view utilization" {

    use_awk gawk
    switch_context cluster-big

    run /code/kubectl-view-utilization

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Req  %Req   Lim  %Lim  Alloc  Free" ]]
    [[ "${lines[1]}" == "CPU         98   18%     0    0%    538   439" ]]
    [[ "${lines[2]}" == "Memory    144G    8%     0    0%   1.6T  1.5T" ]]
}

@test "cluster-big (mawk)> kubectl view utilization" {

    use_awk mawk
    switch_context cluster-big

    run /code/kubectl-view-utilization

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Req  %Req   Lim  %Lim  Alloc  Free" ]]
    [[ "${lines[1]}" == "CPU         98   18%     0    0%    538   439" ]]
    [[ "${lines[2]}" == "Memory    144G    8%     0    0%   1.6T  1.5T" ]]
}

@test "cluster-big (original-awk)> kubectl view utilization" {

    use_awk original-awk
    switch_context cluster-big

    run /code/kubectl-view-utilization

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Req  %Req   Lim  %Lim  Alloc  Free" ]]
    [[ "${lines[1]}" == "CPU         98   18%     0    0%    538   439" ]]
    [[ "${lines[2]}" == "Memory    144G    8%     0    0%   1.6T  1.5T" ]]
}


@test "cluster-big (gawk)> kubectl view-utilization namespaces" {

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

@test "cluster-big (mawk)> kubectl view-utilization namespaces" {

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

@test "cluster-big (original-awk)> kubectl view-utilization namespaces" {

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

@test "cluster-big (gawk)> kubectl view-utilization masters" {

    use_awk gawk
    switch_context cluster-big

    run /code/kubectl-view-utilization -l node-role.kubernetes.io/master=true

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Req  %Req   Lim  %Lim  Alloc  Free" ]]
    [[ "${lines[1]}" == "CPU        8.7   54%     0    0%     16   7.3" ]]
    [[ "${lines[2]}" == "Memory    6.4G   10%     0    0%    60G   54G" ]]
}


@test "cluster-bug1 (original-awk)> kubectl view utilization" {

    use_awk original-awk
    switch_context cluster-bug1

    run /code/kubectl-view-utilization

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Req  %Req   Lim  %Lim  Alloc  Free" ]]
    [[ "${lines[1]}" == "CPU          0    0%     0    0%      6     6" ]]
    [[ "${lines[2]}" == "Memory    3.4G   86%     0    0%   3.9G  519M" ]]
}

@test "cluster-bug1 (gawk)> kubectl view utilization" {

    use_awk gawk
    switch_context cluster-bug1

    run /code/kubectl-view-utilization

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Req  %Req   Lim  %Lim  Alloc  Free" ]]
    [[ "${lines[1]}" == "CPU          0    0%     0    0%      6     6" ]]
    [[ "${lines[2]}" == "Memory    3.4G   86%     0    0%   3.9G  519M" ]]
}

@test "cluster-bug1 (mawk)> kubectl view utilization" {

    use_awk mawk
    switch_context cluster-bug1

    run /code/kubectl-view-utilization

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Req  %Req   Lim  %Lim  Alloc  Free" ]]
    [[ "${lines[1]}" == "CPU          0    0%     0    0%      6     6" ]]
    [[ "${lines[2]}" == "Memory    3.4G   86%     0    0%   3.9G  519M" ]]
}




@test "cluster-bug1 (original-awk)> kubectl view-utilization namespaces" {

    use_awk original-awk
    switch_context cluster-bug1

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "NAMESPACE     CPU Requests     CPU Limits     Memory Requests     Memory Limits" ]]
    [[ "${lines[1]}" == "infra                    0              0                3.4G                 0" ]]
}

@test "cluster-bug1 (gawk)> kubectl view-utilization namespaces" {

    use_awk gawk
    switch_context cluster-bug1

    run /code/kubectl-view-utilization namespaces

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "NAMESPACE     CPU Requests     CPU Limits     Memory Requests     Memory Limits" ]]
    [[ "${lines[1]}" == "infra                    0              0                3.4G                 0" ]]
}

@test "cluster-bug1 (mawk)> kubectl view-utilization namespaces" {

    use_awk mawk
    switch_context cluster-bug1

    run /code/kubectl-view-utilization namespaces

    echo "${output}"
    [ $status -eq 0 ]
    [[ "${lines[0]}" == "NAMESPACE     CPU Requests     CPU Limits     Memory Requests     Memory Limits" ]]
    [[ "${lines[1]}" == "infra                    0              0                3.4G                 0" ]]
}



