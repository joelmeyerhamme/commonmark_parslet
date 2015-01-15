require './commonmark_parslet'
require 'parslet/rig/rspec'
Bundler.require(:default, :test)

CodeClimate::TestReporter.start
Coveralls.wear!
