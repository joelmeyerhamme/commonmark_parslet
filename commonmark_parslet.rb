require 'rubygems'
require 'bundler'
Bundler.require(:default)
require './unicode_data/char_class'

module CommonMark
  class Parser < Parslet::Parser
  end
end

require './parser/preliminaries'
require './transform/html'
