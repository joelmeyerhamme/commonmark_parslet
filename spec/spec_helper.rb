require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require './commonmark_parslet'
Bundler.require(:test, :develop)
require 'parslet/rig/rspec'
require 'parslet/convenience'

