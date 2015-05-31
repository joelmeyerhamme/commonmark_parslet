require 'bundler'
Bundler.require(:default, :test)
require 'parslet/rig/rspec'
require 'parslet/convenience'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_group 'Libraries', 'lib'
  add_filter 'spec'
end

require './commonmark_parslet'
