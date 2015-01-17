require 'bundler'
Bundler.require(:default, :test)
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_group 'Libraries', 'lib'
  add_filter 'spec'
end
require './commonmark_parslet'
require 'parslet/rig/rspec'

