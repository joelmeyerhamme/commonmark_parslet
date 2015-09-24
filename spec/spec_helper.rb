require './commonmark_parslet'
Bundler.require(:test)
require 'parslet/rig/rspec'
require 'parslet/convenience'

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
