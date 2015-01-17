require 'rubygems'
require 'bundler'
Bundler.require(:default)
require './lib/unicode_data/char_class'

module CommonMark
  class Parser < Parslet::Parser
  end
end

require './lib/parser/preliminaries'
require './lib/parser/leaf_block'
require './lib/parser/leaf_block/hrule'
require './lib/parser/leaf_block/atx_header'
require './lib/parser/leaf_block/setext_header'
require './lib/transform/html'
