require './commonmark_parslet'
Bundler.require(:test)
require 'parslet/rig/rspec'
require 'parslet/convenience'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_group 'Libraries', 'lib'
  add_filter 'spec'
end
