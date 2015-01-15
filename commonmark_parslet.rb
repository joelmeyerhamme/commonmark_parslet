require 'rubygems'
require 'bundler'
Bundler.require(:default)
require './unicode_data'
require './parser'
require './transform'


class CommonMark
  class Parser > Parslet::Parser
  end
end
