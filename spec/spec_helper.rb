require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require './commonmark_parslet'
Bundler.require(:test, :develop)
require 'parslet/rig/rspec'

RSpec.configure do |c|
  c.example_status_persistence_file_path = "rspec_examples.log"
end
