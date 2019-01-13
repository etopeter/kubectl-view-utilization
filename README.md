# kubectl-utilization
This repository implements kubectl plugin for showing cluster resource utilization. This is can be used to estimate cluster capacity and and estimate overprovisioned resoures or estimate autoscaling metrics.


## Installation
### Install with krew
1. [Install krew](https://github.com/GoogleContainerTools/krew) plugin manager
   for kubectl.
2. Run `kubectl krew install utilization`.
3. Start using by running `kubectl utilization`.

### Install with Curl
For Kubernetes 1.12 or newer:
```shell
mkdir -p ~/.kube/plugins/utilization && \
curl -sL https://github.com/etopeter/kubectl-utilization/releases/download/v1.0.0/kubectl-utilization-v1.0.0.tar.gz | tar xzvf - -C ~/.kube/plugin/utilization
export PATH=$PATH:~/.kube/plugins/kubectl-utilization/
```

## Usage
This plugin should be invoked with kubectl command, and will appear as subcommand. It will use the existing context configured in `$KUBECONFIG` file.

```shell
kubectl utilization                          
cores 3.2/20 (16%)
memory 7.7GiB/76GiB (10%)
```
