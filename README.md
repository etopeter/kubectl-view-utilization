# `view-utilization` - kubectl plugin to view utilization

---
[![Build Status](https://travis-ci.org/etopeter/kubectl-view-utilization.svg?branch=master)](
https://travis-ci.org/etopeter/kubectl-view-utilization) [![Test Coverage](
https://api.codeclimate.com/v1/badges/88ad27e772eac5a4e19d/test_coverage)](
https://codeclimate.com/github/etopeter/kubectl-view-utilization/test_coverage) [![license](
https://img.shields.io/github/license/etopeter/kubectl-view-utilization.svg)](
https://github.com/etopeter/kubectl-view-utilization/blob/master/LICENSE
) [![contributions welcome](
https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](
https://github.com/etopeter/kubectl-view-utilization/issues)

<p align="center">
<img src="static/view-utilization.png" alt="view-utilization" width=96>
</p>

`view-utilization` kubectl plugin that shows cluster resource utilization. It is written in
BASH/awk and uses kubectl tool to gather information. You can use it to
estimate cluster capacity and see at a glance overprovisioned resoures
with this simple command **`kubectl view-utilization`**.

## Installation

### krew (kubectl plugin manager)

1. [Install krew](https://github.com/GoogleContainerTools/krew)
   plugin manager for kubectl.
1. Run `kubectl krew install view-utilization`.
1. Update plugin with `kubectl krew upgrade view-utilization`

### macOS

On macOS, plugin can be installed via [Homebrew](https://homebrew.sh):

```shell
brew tap etopeter/tap
brew install kubectl-view-utilization
```

### Install with Curl

For Kubernetes 1.12 or newer:

```shell
# Get latest tag
VIEW_UTILIZATION_PATH=/usr/local/bin
VIEW_UTILIZATION_TAG=$(curl -s https://api.github.com/repos/etopeter/kubectl-view-utilization/releases/latest | grep  "tag_name"| sed -E 's/.*"([^"]+)".*/\1/')

# Download and unpack plugin
curl -sL "https://github.com/etopeter/kubectl-view-utilization/releases/download/${VIEW_UTILIZATION_TAG}/kubectl-view-utilization-${VIEW_UTILIZATION_TAG}.tar.gz" |tar xzvf - -C $VIEW_UTILIZATION_PATH

# Rename file if you want to use kubectl view-utilization or leave it if you want to invoke it with kubectl view utilization (with space between). Underscore between words allows kubernetes plugin to have hyphen between words.
mv $VIEW_UTILIZATION_PATH/kubectl-view-utilization $VIEW_UTILIZATION_PATH/kubectl-view_utilization

# Change permission to allow execution
chmod +x $VIEW_UTILIZATION_PATH/kubectl-view_utilization

# Check if plugin is detected
kubectl plugin list
```

### Dependencies

While we try to be as minimalistic as possible the only dependency is AWK.

- kubectl
- bash
- awk (gawk, mawk, awk)

## Usage

This plugin should be invoked with kubectl command, and will appear as
subcommand. It will use the existing context configured in `$KUBECONFIG` file.
You can override context with `--context` parameter.

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

Example usage:

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

Breakdown of node utilization `kubectl view-utilization nodes`

```shell
CPU   : ▆▆▆▆▅▅▇▄▄▆▂▆
Memory: ▇▅▆▇▇▅▅▄▆▇▁▆
                                           CPU                 Memory               
Node                                       Req   %R  Lim   %L  Req   %R  Lim   %L
ip-10-0-0-175.us-east-1.compute.internal   8.1  53%   13   86%  24G  83%  31G  105%
ip-10-0-0-55.us-east-1.compute.internal    6.6  43%   13   90%  19G  64%  22G   76%
ip-10-0-18-238.us-east-1.compute.internal    7  46%   12   85%  24G  82%  25G   86%
ip-10-0-19-235.us-east-1.compute.internal   10  67%   14   93%  27G  92%  29G   98%
ip-10-0-21-0.us-east-1.compute.internal    9.5  63%   12   83%  25G  86%  30G  101%
ip-10-0-28-44.us-east-1.compute.internal   6.9  45%   10   70%  20G  70%  24G   81%
ip-10-0-3-133.us-east-1.compute.internal     6  40%   14   97%  20G  67%  24G   83%
ip-10-0-3-24.us-east-1.compute.internal    5.9  39%   10   66%  17G  57%  19G   63%
ip-10-0-35-119.us-east-1.compute.internal  7.7  51%   10   66%  23G  78%  28G   94%
ip-10-0-39-146.us-east-1.compute.internal   10  66%   13   90%  25G  84%  30G  101%
ip-10-0-40-184.us-east-1.compute.internal  3.6  23%  5.7   37%  11G  17%  13G   21%
ip-10-0-42-24.us-east-1.compute.internal   6.6  43%   13   90%  22G  76%  26G   88%
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

Output to JSON format.

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

---

## Simplify workflow with aliases

Add to your `~/.bash_profile` or `~/.zshrc`

```shell
alias kvu="kubectl view-utilization -h"
```

Now you can use `kvu` alias to quickly show resource usage

Example commands:

```shell
kvu
kvu namespaces
kvu -n kube-system
```

---

## Change log

See the [CHANGELOG](CHANGELOG.md) file for details.

## Developing

1. Clone this repo with git
1. Test locally with kubectl pointing to your cluster (minikube or full cluster)
1. Run unit tests `make test`
