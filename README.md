# kubectl-utilization
This repository implements kubectl plugin for showing cluster resource utilization. 
This is can be used to estimate cluster capacity and see at a glance overprovisioned resoures.
I'ts useful to have such tool if you need to know if you have enough overhead to handle pod autoscaling
without having to setting up more complicated metrics dashboards, especially when you have many smaller clusters.

## Installation
### Install with krew
1. [Install krew](https://github.com/GoogleContainerTools/krew) plugin manager for kubectl.
2. Run `kubectl krew install utilization`.
3. Start using by running `kubectl utilization`.

### Install with Curl
For Kubernetes 1.12 or newer:
```shell
mkdir -p ~/.kube/plugins/utilization && \
curl -sL https://github.com/etopeter/kubectl-utilization/releases/download/v1.0.1/kubectl-utilization-v1.0.1.tar.gz | tar xzvf - -C ~/.kube/plugin/utilization
export PATH=$PATH:~/.kube/plugins/kubectl-utilization/
```

## Usage
This plugin should be invoked with kubectl command, and will appear as subcommand. It will use the existing context configured in `$KUBECONFIG` file.

```shell
kubectl utilization                          
cores: 3.2/20 cores (16%)
memory: 7.7 GiB/76 GiB (10%)
```
Check utilization for specific namespace:

```shell
kubectl utilization -n kube-system
cores: 0.5/20 cores (2%)
memory: 5 GiB/76 GiB (6%)
```
