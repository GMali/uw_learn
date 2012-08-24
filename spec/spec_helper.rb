require_relative '../lib/uw_learn'
 
require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'
require 'turn'
 
Turn.config do |c|
 # :outline  - turn's original case/test outline mode [default]
 c.format  = :outline
 # turn on invoke/execute tracing, enable full backtrace
 c.trace   = true
 # use humanized test names (works only with :outline format)
 c.natural = true
end
 
=begin
## Testing all web scraping/parsing cases is too painful to execute. ##
## Tests were run manually to ensure working library for simple cases. ##
VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/'
  c.hook_into :webmock
end
=end
