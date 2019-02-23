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
Krew makes update process very simple. To update to latest version run `kubectl krew upgrade view-utilization`


### Install with Curl
For Kubernetes 1.12 or newer:
```shell
mkdir -p ~/.kube/plugins/view-utilization && \
curl -sL https://github.com/etopeter/kubectl-view-utilization/releases/download/v0.1.4/kubectl-view-utilization-v0.1.4.tar.gz | tar xzvf - -C ~/.kube/plugins/view-utilization
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
Human readable format `-h`
```shell
kubectl view-utilization -h
Resource  Req   %R  Lim    %L  Alloc  Sched  Free
CPU        43  81%   70  132%     53    9.7     0
Memory    88G  42%    0   66%   208G   120G   70G
```
Check utilization for specific namespace `-n`

```shell
kubectl view-utilization -h -n kube-system
Resource   Req  %R  Lim  %L  Alloc  Sched  Free
CPU        3.5  6%  4.2  7%     53     49    48
Memory    5.1G  2%    0  3%   208G   202G  200G
```

Check utilization for node groups using label filters.
Example filter results only for nodes in availability zone us-west-2b `failure-domain.beta.kubernetes.io/zone=us-west-2b`:

```shell
./kubectl-view-utilization -l failure-domain.beta.kubernetes.io/zone=us-west-2b -h
Resource  Req   %R  Lim    %L  Alloc  Sched  Free
CPU        19  84%   31  137%     22    3.6     0
Memory    39G  43%    0   68%    89G    50G   28G
```

Overview of namespace utilization `kubectl view-utilization namespaces`
```shell
kubectl view-utilization namespaces
NAMESPACE       CPU   MEMORY
dev               0        0
kube-system       3       3G
monitoring      0.3     1.5G
prewiew           4       9G
rc                4       9G
qa                4       9G
```
