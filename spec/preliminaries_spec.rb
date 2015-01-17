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
    CommonMark::Parser::Preliminaries.ascii_punctuation_chars.each do |p|
      is_expected.to parse(p)
    end
  end

  it "should parse unicode whitespace" do
    CommonMark::Parser::Preliminaries.unicode_space_chars.each do |ch|
      is_expected.to parse(ch)
    end
  end

  it "should parse unicode punctuation" do
    CommonMark::Parser::Preliminaries.unicode_punctuation_chars.each do |ch|
      is_expected.to parse(ch)
    end
  end

  describe "tab expansion" do
    it "should expand inline tabs to 4 chars" do
      pending "put tabbing monstly into renderers?"
      expect(subject.parse("\tfoo\tbaz\t\tbim")).to eq("<pre><code>foo baz     bim\n</code></pre>")
      expect(subject.parse("    a\ta\n    ὐ\ta")).to eq("<pre><code>a   a\nὐ   a\n</code></pre>")
    end
  end
end
