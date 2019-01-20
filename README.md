# kubectl-view-utilization [![Build Status](https://travis-ci.org/etopeter/kubectl-view-utilization.svg?branch=master)](https://travis-ci.org/etopeter/kubectl-view-utilization)

This repository implements kubectl plugin for showing cluster resource utilization. 
This is can be used to estimate cluster capacity and see at a glance overprovisioned resoures.
I'ts useful to have such tool if you need to know if you have enough overhead to handle pod autoscaling
without having to setting up more complicated metrics dashboards, especially when you have many smaller clusters.

## Installation
### Dependincies

- bash
- bc
- awk

### Install with krew
1. [Install krew](https://github.com/GoogleContainerTools/krew) plugin manager for kubectl.
2. Run `kubectl krew install view-utilization`.
3. Start using by running `kubectl view-utilization`.

### Install with Curl
For Kubernetes 1.12 or newer:
```shell
mkdir -p ~/.kube/plugins/view-utilization && \
curl -sL https://github.com/etopeter/kubectl-view-utilization/releases/download/v0.1.1/kubectl-view-utilization-v0.1.1.tar.gz | tar xzvf - -C ~/.kube/plugins/view-utilization
export PATH=$PATH:~/.kube/plugins/view-utilization/
```

## Usage
This plugin should be invoked with kubectl command, and will appear as subcommand. It will use the existing context configured in `$KUBECONFIG` file.

```shell
kubectl view-utilization                          
cores      2.3 / 8       (28%)
memory  1.2GiB / 30GiB   (4%)
```
Check utilization for specific namespace:

```shell
kubectl view-utilization -n kube-system
cores:    0.5 / 20      (2%)
memory:  5GiB / 76GiB   (6%)
```
Overview of namespace utilization `kubectl view-utilization namespaces`
```shell
kubectl view-utilization namespaces
NAMESPACE       CPU    MEMORY
rc                4     9 GiB
prewiew           4     9 GiB
dev               0         0
monitoring      0.3   1.5 GiB
qa                4     9 GiB
kube-system       3     3 GiB
```
