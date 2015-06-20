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
require './lib/parser/leaf_block/indented_block'
require './lib/parser/leaf_block/fenced_block'
require './lib/parser/leaf_block/html_block'
require './lib/parser/leaf_block/link_reference_definition'
require './lib/parser/leaf_block/paragraph'
require './lib/transform/html'
