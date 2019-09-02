# v0.3.0
- New subcommand `nodes` shows nodes utilization breakdown with shall chart
- Added --context parameter to switch kubeconfig contexts [Issue #36](https://github.com/etopeter/kubectl-view-utilization/issues/36)
- Added --no-headers to supress printing headers just like kubeclt does
- Fix for double counting CPU when resources were defined without (m) at the end
- Improved unit tests, added Codeclimate integration.

# v0.2.2

- Fix for unschedulable nodes showing in utilization. [Issue #34](https://github.com/etopeter/kubectl-view-utilization/issues/34)
