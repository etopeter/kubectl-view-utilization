f ENV['CI'] == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

SimpleCov.start do
  minimum_coverage 95
  add_filter "/tmp/"
  add_filter "/usr/local/bin/"
  add_filter "/.git/"
end
