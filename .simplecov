SimpleCov.start do
  minimum_coverage 95
  add_filter "/.git/"
  add_filter "/static/"
  add_filter "/test/"
  add_group "app", 'kubectl-view-utilization'
end
