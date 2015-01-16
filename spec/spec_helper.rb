Bundler.require(:default, :test)
require 'parslet/rig/rspec'
CodeClimate::TestReporter.start
Coveralls.wear!
require './commonmark_parslet'

