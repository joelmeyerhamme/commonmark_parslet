require './spec/spec_helper'

describe CommonMark::Parser::Preliminaries do
  it "should parse whitespace" do
    is_expected.to parse("\t")
    is_expected.to parse(" ")
    is_expected.to parse("\r")
    is_expected.to parse("\0")
    is_expected.to parse("\n")
  end

  it "should parse ascii punctuation" do
    CommonMark::Parser::Preliminaries::ASCII_PUNCTUATION.each do |p|
      is_expected.to parse(p)
    end
  end

  it "should parse unicode whitespace" do
    CommonMark::Parser::Preliminaries.unicode_space.each do |ch|
      is_expected.to parse(ch)
    end
  end

  it "should parse unicode punctuation" do
    CommonMark::Parser::Preliminaries.unicode_punctuation.each do |ch|
      is_expected.to parse(ch)
    end
  end
end
