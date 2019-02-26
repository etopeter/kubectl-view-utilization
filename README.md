# kubectl-view-utilization [![Build Status](https://travis-ci.org/etopeter/kubectl-view-utilization.svg?branch=master)](https://travis-ci.org/etopeter/kubectl-view-utilization)

This repository implements kubectl plugin for showing cluster resource utilization. 
This is can be used to estimate cluster capacity and see at a glance overprovisioned resoures.
It's useful to have such tool if you need to know if you have enough overhead to handle pod autoscaling
without having to setting up more complicated metrics dashboards, especially when you have many smaller clusters.

## Installation
### Install with krew
1. [Install krew](https://github.com/GoogleContainerTools/krew) plugin manager for kubectl.
2. Run `kubectl krew install view-utilization`.
3. Start using by running `kubectl view-utilization`.

### Update with krew
Krew makes update process very simple. To update to latest version run
```shell
kubectl krew upgrade view-utilization
```

### Install with Curl
For Kubernetes 1.12 or newer:
```shell
mkdir -p ~/.kube/plugins/view-utilization && \
curl -sL https://github.com/etopeter/kubectl-view-utilization/releases/download/v0.2.1/kubectl-view-utilization-v0.2.1.tar.gz | tar xzvf - -C ~/.kube/plugins/view-utilization
export PATH=$PATH:~/.kube/plugins/view-utilization/
```

### Dependincies

- bash
- awk (gawk,mawk,awk)


## Usage
This plugin should be invoked with kubectl command, and will appear as subcommand. It will use the existing context configured in `$KUBECONFIG` file.

```shell
kubectl view-utilization                          
Resource     Requests  %Requests        Limits  %Limits   Allocatable   Schedulable         Free
CPU             43475         81         70731      132         53200          9725            0
Memory    94371840000         42  147184418816       66  222828834816  128456994816  75644416000
```

| Column      | Short | Description |
|-------------|-------|-------------|
| Requests    | Req   | Calculated total pod requests across all namespaces |
| %Requests   | %R    | Percentage of total requests agains allocatable requests |
| Limits      | Lim   | Calculated total pod limits across all namespaces  |
| %Limits     | %L    | Percentage of tatal limits agains allocatable limits |
| Allocatable | Alloc | Available allocatable resources |
| Schedulable | Sched | Resources that can be used to schedule pods; Available for pod requests (allocatable - requests) |
| Free        | Free  | Resources that are outside all requests or limits |


Human readable format `-h`
```shell
kubectl view-utilization -h
Resource  Req   %R   Lim    %L  Alloc  Sched  Free
CPU        43  71%    71  117%     60     17     0
Memory    88G  37%  138G   58%   237G   149G   99G
```
Check utilization for specific namespace `-n`

```shell
kubectl view-utilization -h -n kube-system
Resource   Req  %R   Lim  %L  Alloc  Sched  Free
CPU        3.7  6%   4.3  7%     60     57    56
Memory    5.4G  2%  7.9G  3%   237G   232G  229G 
```

Check utilization for node groups using label filters.
Example filter results only for nodes in availability zone us-west-2b `failure-domain.beta.kubernetes.io/zone=us-west-2b`:

```shell
kubectl view-utilization -l failure-domain.beta.kubernetes.io/zone=us-west-2b -h
Resource  Req   %R  Lim    %L  Alloc  Sched  Free
CPU        14  64%   24  106%     22      8     0
Memory    30G  33%  47G   52%    89G    59G   42G
```

Overview of namespace utilization `kubectl view-utilization namespaces`
```shell
kubectl view-utilization namespaces -h
             CPU        Memory      
Namespace     Req  Lim   Req   Lim
analitics     6.6   10   14G   21G
kube-system   3.5  4.2  5.1G  7.6G
lt             13   21   27G   42G
monitoring   0.35  3.5  1.8G  3.5G
qa             13   21   27G   42G
rc            6.6   10   14G   21G
```

Output json
```shell
kubectl view-utilization -o json | jq
{
  "CPU": {
    "requested": 43740,
    "limits": 71281,
    "allocatable": 60800,
    "schedulable": 17060,
    "free": 0
  },
  "Memory": {
    "requested": 94942265344,
    "limits": 148056834048,
    "allocatable": 254661525504,
    "schedulable": 159719260160,
    "free": 106604691456
  }
}
```
