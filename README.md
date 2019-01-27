# kubectl-view-utilization [![Build Status](https://travis-ci.org/etopeter/kubectl-view-utilization.svg?branch=master)](https://travis-ci.org/etopeter/kubectl-view-utilization)

This repository implements kubectl plugin for showing cluster resource utilization. 
This is can be used to estimate cluster capacity and see at a glance overprovisioned resoures.
I'ts useful to have such tool if you need to know if you have enough overhead to handle pod autoscaling
without having to setting up more complicated metrics dashboards, especially when you have many smaller clusters.

## Installation
### Dependincies

- bash
- awk

### Install with krew
1. [Install krew](https://github.com/GoogleContainerTools/krew) plugin manager for kubectl.
2. Run `kubectl krew install view-utilization`.
3. Start using by running `kubectl view-utilization`.

### Install with Curl
For Kubernetes 1.12 or newer:
```shell
mkdir -p ~/.kube/plugins/view-utilization && \
curl -sL https://github.com/etopeter/kubectl-view-utilization/releases/download/v0.1.2/kubectl-view-utilization-v0.1.2.tar.gz | tar xzvf - -C ~/.kube/plugins/view-utilization
export PATH=$PATH:~/.kube/plugins/view-utilization/
```

## Usage
This plugin should be invoked with kubectl command, and will appear as subcommand. It will use the existing context configured in `$KUBECONFIG` file.

```shell
kubectl view-utilization                          
cores      2.3 / 8   (28%)
memory  1.2G / 30G   (4%)
```
Check utilization for specific namespace:

```shell
kubectl view-utilization -n kube-system
cores:   0.5 / 20   (2%)
memory:  5G / 76G   (6%)
```

Check utilization for node groups using label filters.
Example filter out master nodes `node-role.kubernetes.io/master=true`:

```shell
kubectl view-utilization -l node-role.kubernetes.io/master=true
cores:    0.5 / 8   (2%)
memory:  1G / 24G   (4%)
```

Overview of namespace utilization `kubectl view-utilization namespaces`
```shell
kubectl view-utilization namespaces
NAMESPACE       CPU   MEMORY
rc                4       9G
prewiew           4       9G
dev               0        0
monitoring      0.3     1.5G
qa                4       9G
kube-system       3       3G
```
