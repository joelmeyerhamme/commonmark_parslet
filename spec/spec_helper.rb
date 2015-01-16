require './commonmark_parslet'
require 'parslet/rig/rspec'
Bundler.require(:default, :test)

Coveralls.wear!
# CodeClimate::TestReporter.start
