require 'rubygems'
require 'bundler'
Bundler.require(:default)
require './unicode_data'

class CommonMark
end

class CommonMark::Parser < Parslet::Parser
end

require './parser'
require './transform'
