# kubectl-utilization
This repository implements kubectl plugin for showing cluster resource utilization. This is can be used to estimate cluster capacity and and estimate overprovisioned resoures or estimate autoscaling metrics.


## Installation
copy kubectl-utilization to location in your `$PATH`. This tool is written in BASH and requires `awk` and `bc` to be installed.

## Usage
This plugin should be invoked with kubectl command and will appear as subcommand. It will use existing context configured in `$KUBECONFIG` file.

`shell
kubectl utilization                          
cores 3.2/20 (16%)
memory 7.7GiB/76GiB (10%)
`
