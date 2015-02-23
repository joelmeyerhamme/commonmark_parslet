require './spec/spec_helper'
# require 'byebug'

describe CommonMark::Parser::LeafBlock::IndentedBlock do
  it "should parse indented blocks" do
    is_expected.to parse("    a simple\n      indented code block")
  end

  it "should parse indented blocks with blank lines" do
    is_expected.to parse("    chunk1\n\n    chunk2\n\n\n    chunk3")
  end

  it "should parse indented blocks with single blank line" do
    is_expected.to parse("    chunk1\n\n    chunk2")
  end
end
