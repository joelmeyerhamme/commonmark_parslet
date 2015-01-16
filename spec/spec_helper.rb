Bundler.require(:default, :test)
require 'parslet/rig/rspec'
Coveralls.wear!
CodeClimate::TestReporter.start
require './commonmark_parslet'

