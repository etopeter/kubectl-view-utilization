# v0.3.3
- Fixed node memory parsing when memory reports as integers without units [Issue #55](https://github.com/etopeter/kubectl-view-utilization/issues/56)
- Fixed context verification [Issue #55](https://github.com/etopeter/kubectl-view-utilization/issues/55)
- Fixed utilization view not displaying when requests are set to 0 in normal mode

# v0.3.2
- Fixed handling of node allocatable memory parsing [Issue #52](https://github.com/etopeter/kubectl-view-utilization/issues/52)

# v0.3.1
- Fixed node view graph not showing for low utilization nodes [Issue #49](https://github.com/etopeter/kubectl-view-utilization/issues/49)

# v0.3.0
- New subcommand `nodes` shows nodes utilization breakdown with shall chart
- Added --context parameter to switch kubeconfig contexts [Issue #36](https://github.com/etopeter/kubectl-view-utilization/issues/36)
- Added --no-headers to supress printing headers just like kubeclt does
- Fix for double counting CPU when resources were defined without (m) at the end
- Improved unit tests, added Codeclimate integration.

# v0.2.2

- Fix for unschedulable nodes showing in utilization. [Issue #34](https://github.com/etopeter/kubectl-view-utilization/issues/34)
