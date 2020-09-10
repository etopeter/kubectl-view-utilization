#!/usr/bin/env bats
set -a

load helper_functions
load mocks/kubectl

@test "[u1] cluster-small (gawk)> kubectl view utilization -o text" {

    use_awk gawk 
    switch_context cluster-small

    run /code/kubectl-view-utilization -o text

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Requests  %Requests     Limits  %Limits  Allocatable  Schedulable        Free" ]]
    [[ "${lines[1]}" == "CPU              70          7        340       37          898          828         558" ]]
    [[ "${lines[2]}" == "Memory    381681664         13  658608128       23   2767106048   2385424384  2108497920" ]]
}

@test "[u2] cluster-small (gawk)> kubectl view utilization -o text -h" {

    use_awk gawk 
    switch_context cluster-small

    run /code/kubectl-view-utilization -o text -h

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Req   %R   Lim   %L  Alloc  Sched  Free" ]]
    [[ "${lines[1]}" == "CPU       0.07   7%  0.34  37%    0.9   0.83  0.56" ]]
    [[ "${lines[2]}" == "Memory    364M  13%  628M  23%   2.6G   2.2G    2G" ]]
}

@test "[u3] cluster-small (gawk)> kubectl view utilization output to json" {

    use_awk gawk 
    switch_context cluster-small

    run /code/kubectl-view-utilization -o json

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == '{"CPU": {"requested": 70,"limits": 340,"allocatable": 898,"schedulable": 828,"free": 558},"Memory": {"requested": 381681664,"limits": 658608128,"allocatable": 2767106048,"schedulable": 2385424384,"free": 2108497920}}' ]]
}

@test "[u3.1] cluster-small (gawk)> kubectl view utilization output to json human readable" {

    use_awk gawk 
    switch_context cluster-small

    run /code/kubectl-view-utilization -h -o json

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == '{"CPU": {"requested": "0.07","limits": "0.34","allocatable": "0.9","schedulable": "0.83","free": "0.56"},"Memory": {"requested": "364M","limits": "628M","allocatable": "2.6G","schedulable": "2.2G","free": "2G"}}' ]]
}


@test "[u4] cluster-small (gawk)> kubectl view-utilization masters" {

    use_awk gawk
    switch_context cluster-small

    run /code/kubectl-view-utilization --selector=node-role.kubernetes.io/master=true

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Requests  %Requests     Limits  %Limits  Allocatable  Schedulable       Free" ]]
    [[ "${lines[1]}" == "CPU              60         13        200       44          449          389        249" ]]
    [[ "${lines[2]}" == "Memory    314572800         22  524339200       37   1383553024   1068980224  859213824" ]]
}

@test "[u5] cluster-small (gawk)> kubectl view-utilization masters -h" {

    use_awk gawk
    switch_context cluster-small

    run /code/kubectl-view-utilization --selector=node-role.kubernetes.io/master=true -h

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Req   %R   Lim   %L  Alloc  Sched  Free" ]]
    [[ "${lines[1]}" == "CPU       0.06  13%   0.2  44%   0.45   0.39  0.25" ]]
    [[ "${lines[2]}" == "Memory    300M  22%  500M  37%   1.3G  1019M  819M" ]]
}

@test "[u6] cluster-medium (gawk)> kubectl view utilization --output=text" {

    use_awk gawk 
    switch_context cluster-medium

    run /code/kubectl-view-utilization --output=text

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource     Requests  %Requests  Limits  %Limits   Allocatable   Schedulable          Free" ]]
    [[ "${lines[1]}" == "CPU             20820         69       0        0         29908          9088          9088" ]]
    [[ "${lines[2]}" == "Memory    13608419328         11       0        0  119148531712  105540112384  105540112384" ]]
}

@test "[u7] cluster-medium (gawk)> kubectl view utilization --output text -h" {

    use_awk gawk 
    switch_context cluster-medium

    run /code/kubectl-view-utilization --output text -h

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource  Req   %R  Lim  %L  Alloc  Sched  Free" ]]
    [[ "${lines[1]}" == "CPU        20  69%    0  0%     29    9.1   9.1" ]]
    [[ "${lines[2]}" == "Memory    13G  11%    0  0%   111G    98G   98G" ]]
}

@test "[u8] cluster-medium (mawk)> kubectl view utilization --output text" {

    use_awk mawk
    switch_context cluster-medium --output text

    run /code/kubectl-view-utilization

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource     Requests  %Requests  Limits  %Limits   Allocatable   Schedulable          Free" ]]
    [[ "${lines[1]}" == "CPU             20820         69       0        0         29908          9088          9088" ]]
    [[ "${lines[2]}" == "Memory    13608419328         11       0        0  119148531712  105540112384  105540112384" ]]
}

@test "[u9] cluster-medium (mawk)> kubectl view utilization -o text -h" {

    use_awk mawk
    switch_context cluster-medium

    run /code/kubectl-view-utilization -o text -h

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource  Req   %R  Lim  %L  Alloc  Sched  Free" ]]
    [[ "${lines[1]}" == "CPU        20  69%    0  0%     29    9.1   9.1" ]]
    [[ "${lines[2]}" == "Memory    13G  11%    0  0%   111G    98G   98G" ]]
}

@test "[u10] cluster-medium (original-awk)> kubectl view utilization" {

    use_awk original-awk
    switch_context cluster-medium

    run /code/kubectl-view-utilization

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource     Requests  %Requests  Limits  %Limits   Allocatable   Schedulable          Free" ]]
    [[ "${lines[1]}" == "CPU             20820         69       0        0         29908          9088          9088" ]]
    [[ "${lines[2]}" == "Memory    13608419328         11       0        0  119148531712  105540112384  105540112384" ]]
}

@test "[u11] cluster-medium (gawk)> kubectl view-utilization masters" {

    use_awk gawk
    switch_context cluster-medium

    run /code/kubectl-view-utilization --selector node-role.kubernetes.io/master=true

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource    Requests  %Requests  Limits  %Limits  Allocatable  Schedulable         Free" ]]
    [[ "${lines[1]}" == "CPU             4284         72       0        0         5884         1600         1600" ]]
    [[ "${lines[2]}" == "Memory    2535456768         11       0        0  21764829184  19229372416  19229372416" ]]
}

@test "[u12] cluster-medium (gawk)> kubectl view-utilization masters -h" {

    use_awk gawk
    switch_context cluster-medium

    run /code/kubectl-view-utilization --selector node-role.kubernetes.io/master=true -h

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Req   %R  Lim  %L  Alloc  Sched  Free" ]]
    [[ "${lines[1]}" == "CPU        4.3  72%    0  0%    5.9    1.6   1.6" ]]
    [[ "${lines[2]}" == "Memory    2.4G  11%    0  0%    20G    18G   18G" ]]
}


@test "[u13] cluster-big (gawk)> kubectl view utilization" {

    use_awk gawk
    switch_context cluster-big

    run /code/kubectl-view-utilization

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource      Requests  %Requests  Limits  %Limits    Allocatable    Schedulable           Free" ]]
    [[ "${lines[1]}" == "CPU              98878         18       0        0         538416         439538         439538" ]]
    [[ "${lines[2]}" == "Memory    154268598272          8       0        0  1790902091776  1636633493504  1636633493504" ]]
}

@test "[u14] cluster-big (gawk)> kubectl view utilization -h" {

    use_awk gawk
    switch_context cluster-big

    run /code/kubectl-view-utilization -h

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Req   %R  Lim  %L  Alloc  Sched  Free" ]]
    [[ "${lines[1]}" == "CPU         98  18%    0  0%    538    439   439" ]]
    [[ "${lines[2]}" == "Memory    144G   8%    0  0%   1.6T   1.5T  1.5T" ]]
}

@test "[u15] cluster-big (mawk)> kubectl view utilization" {

    use_awk mawk
    switch_context cluster-big

    run /code/kubectl-view-utilization

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource      Requests  %Requests  Limits  %Limits    Allocatable    Schedulable           Free" ]]
    [[ "${lines[1]}" == "CPU              98878         18       0        0         538416         439538         439538" ]]
    [[ "${lines[2]}" == "Memory    154268598272          8       0        0  1790902091776  1636633493504  1636633493504" ]]
}

@test "[u16] cluster-big (mawk)> kubectl view utilization -h" {

    use_awk mawk
    switch_context cluster-big

    run /code/kubectl-view-utilization -h

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Req   %R  Lim  %L  Alloc  Sched  Free" ]]
    [[ "${lines[1]}" == "CPU         98  18%    0  0%    538    439   439" ]]
    [[ "${lines[2]}" == "Memory    144G   8%    0  0%   1.6T   1.5T  1.5T" ]]
}

@test "[u17] cluster-big (original-awk)> kubectl view utilization" {

    use_awk original-awk
    switch_context cluster-big

    run /code/kubectl-view-utilization

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource      Requests  %Requests  Limits  %Limits    Allocatable    Schedulable           Free" ]]
    [[ "${lines[1]}" == "CPU              98878         18       0        0         538416         439538         439538" ]]
    [[ "${lines[2]}" == "Memory    154268598272          8       0        0  1790902091776  1636633493504  1636633493504" ]]
}

@test "[u18] cluster-big (original-awk)> kubectl view utilization -h" {

    use_awk original-awk
    switch_context cluster-big

    run /code/kubectl-view-utilization -h

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Req   %R  Lim  %L  Alloc  Sched  Free" ]]
    [[ "${lines[1]}" == "CPU         98  18%    0  0%    538    439   439" ]]
    [[ "${lines[2]}" == "Memory    144G   8%    0  0%   1.6T   1.5T  1.5T" ]]
}

@test "[u19] cluster-big (gawk)> kubectl view-utilization masters" {

    use_awk gawk
    switch_context cluster-big

    run /code/kubectl-view-utilization -l node-role.kubernetes.io/master=true

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource    Requests  %Requests  Limits  %Limits  Allocatable  Schedulable         Free" ]]
    [[ "${lines[1]}" == "CPU             8718         54       0        0        16016         7298         7298" ]]
    [[ "${lines[2]}" == "Memory    6851395584         10       0        0  64922468352  58071072768  58071072768" ]]
}

@test "[u20] cluster-big (gawk)> kubectl view-utilization masters -h" {

    use_awk gawk
    switch_context cluster-big

    run /code/kubectl-view-utilization --selector node-role.kubernetes.io/master=true -h

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Req   %R  Lim  %L  Alloc  Sched  Free" ]]
    [[ "${lines[1]}" == "CPU        8.7  54%    0  0%     16    7.3   7.3" ]]
    [[ "${lines[2]}" == "Memory    6.4G  10%    0  0%    60G    54G   54G" ]]
}


@test "[u21] cluster-bug1 (original-awk)> kubectl view utilization" {

    use_awk original-awk
    switch_context cluster-bug1

    run /code/kubectl-view-utilization

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource    Requests  %Requests  Limits  %Limits  Allocatable  Schedulable       Free" ]]
    [[ "${lines[1]}" == "CPU                0          0       0        0         6006         6006       6006" ]]
    [[ "${lines[2]}" == "Memory    3606605824         86       0        0   4150659072    544053248  544053248" ]]
}

@test "[u22] cluster-bug1 (gawk)> kubectl view utilization" {

    use_awk gawk
    switch_context cluster-bug1

    run /code/kubectl-view-utilization

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource    Requests  %Requests  Limits  %Limits  Allocatable  Schedulable       Free" ]]
    [[ "${lines[1]}" == "CPU                0          0       0        0         6006         6006       6006" ]]
    [[ "${lines[2]}" == "Memory    3606605824         86       0        0   4150659072    544053248  544053248" ]]
}

@test "[u23] cluster-bug1 (mawk)> kubectl view utilization" {

    use_awk mawk
    switch_context cluster-bug1

    run /code/kubectl-view-utilization

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource    Requests  %Requests  Limits  %Limits  Allocatable  Schedulable       Free" ]]
    [[ "${lines[1]}" == "CPU                0          0       0        0         6006         6006       6006" ]]
    [[ "${lines[2]}" == "Memory    3606605824         86       0        0   4150659072    544053248  544053248" ]]
}

@test "[u24] cluster-small (gawk)> kubectl view utilization context cluster-small" {

    use_awk gawk 
    switch_context cluster-big

    run /code/kubectl-view-utilization -o text --context=cluster-small

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Requests  %Requests     Limits  %Limits  Allocatable  Schedulable        Free" ]]
    [[ "${lines[1]}" == "CPU              70          7        340       37          898          828         558" ]]
    [[ "${lines[2]}" == "Memory    381681664         13  658608128       23   2767106048   2385424384  2108497920" ]]
}

@test "[u25] cluster-medium (gawk)> kubectl view utilization context cluster-medium" {

    use_awk gawk
    switch_context cluster-small

    run /code/kubectl-view-utilization -o text --context cluster-medium

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource     Requests  %Requests  Limits  %Limits   Allocatable   Schedulable          Free" ]]
    [[ "${lines[1]}" == "CPU             20820         69       0        0         29908          9088          9088" ]]
    [[ "${lines[2]}" == "Memory    13608419328         11       0        0  119148531712  105540112384  105540112384" ]]
}


@test "[u26] cluster-big (original-awk)> kubectl view utilization context cluster-big" {

    use_awk original-awk
    switch_context cluster-small

    run /code/kubectl-view-utilization -o text --context=cluster-big

    echo "${output}"
    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource      Requests  %Requests  Limits  %Limits    Allocatable    Schedulable           Free" ]]
    [[ "${lines[1]}" == "CPU              98878         18       0        0         538416         439538         439538" ]]
    [[ "${lines[2]}" == "Memory    154268598272          8       0        0  1790902091776  1636633493504  1636633493504" ]]
}

@test "[u27] cluster-small (gawk)> kubectl view utilization namespace kube-system" {

    use_awk gawk 
    switch_context cluster-small

    run /code/kubectl-view-utilization -o text -n kube-system

    echo "${output}"
    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource  Requests  %Requests     Limits  %Limits  Allocatable  Schedulable        Free" ]]
    [[ "${lines[1]}" == "CPU             10          1         40        4          898          888         858" ]]
    [[ "${lines[2]}" == "Memory    67108864          2  134217728        4   2767106048   2699997184  2632888320" ]]
}

@test "[u28] cluster-medium (gawk)> kubectl view utilization namespace kube-system" {

    use_awk gawk 
    switch_context cluster-big

    run /code/kubectl-view-utilization --namespace=kube-system

    echo "${output}"
    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Requests  %Requests  Limits  %Limits    Allocatable    Schedulable           Free" ]]
    [[ "${lines[1]}" == "CPU             270          0       0        0         538416         538146         538146" ]]
    [[ "${lines[2]}" == "Memory    455081984          0       0        0  1790902091776  1790447009792  1790447009792" ]]
}

@test "[u29] cluster-issue-52 (original-awk)> kubectl view utilization" {

    use_awk original-awk
    switch_context cluster-issue-52

    run /code/kubectl-view-utilization

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource   Requests  %Requests     Limits  %Limits  Allocatable  Schedulable        Free" ]]
    [[ "${lines[1]}" == "CPU             300         14        350       17         2002         1702        1652" ]]
    [[ "${lines[2]}" == "Memory    314572800          7  419430400       10   4009754624   3695181824  3590324224" ]]
}

@test "[u30] cluster-issue-56 (original-awk)> kubectl view utilization" {

    use_awk original-awk
    switch_context cluster-issue-56

    run /code/kubectl-view-utilization

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource  Requests  %Requests  Limits  %Limits   Allocatable   Schedulable          Free" ]]
    [[ "${lines[1]}" == "CPU              0          0                0        276276        276276        276276" ]]
    [[ "${lines[2]}" == "Memory           0          0                0  585265835050  585265835050  585265835050" ]]
}

@test "[u31] cluster-issue-56 (original-awk)> kubectl view utilization -h" {

    use_awk original-awk
    switch_context cluster-issue-56

    run /code/kubectl-view-utilization -h

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource  Req  %R  Lim  %L  Alloc  Sched  Free" ]]
    [[ "${lines[1]}" == "CPU         0  0%    0  0%    276    276   276" ]]
    [[ "${lines[2]}" == "Memory      0  0%    0  0%   545G   545G  545G" ]]
}

@test "[u32] cluster-issue-56 (original-awk)> kubectl view utilization -h" {

    use_awk original-awk
    switch_context cluster-issue-56

    run /code/kubectl-view-utilization -h -l role=kube-worker

    [ $status -eq 0 ]
    echo "${output}"
    [[ "${lines[0]}" == "Resource  Req  %R  Lim  %L  Alloc  Sched  Free" ]]
    [[ "${lines[1]}" == "CPU         0  0%    0  0%    168    168   168" ]]
    [[ "${lines[2]}" == "Memory      0  0%    0  0%   340G   340G  340G" ]]
}
