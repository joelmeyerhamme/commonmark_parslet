require './spec/spec_helper'

describe CommonMark::Parser::LeafBlock::AtxHeader do
  it "should parse h1" do
    is_expected.to parse("# header")
  end

  it "should parse h2" do
    is_expected.to parse("## header")
  end

  it "should parse h3" do
    is_expected.to parse("### header")
  end

  it "should parse h4" do
    is_expected.to parse("#### header")
  end

  it "should parse h5" do
    is_expected.to parse("##### header")
  end

  it "should parse h6" do
    is_expected.to parse("###### header")
  end

  it "should not parse parse h7" do
    is_expected.not_to parse("####### header")
  end

  it "should not parse missing space" do
    is_expected.not_to parse("#5 bolt")
  end

  it "should not parse escaped octothorpe" do
    is_expected.not_to parse("\\## foo")
  end

  it "should parse inlines" do
    pending "inlines not yet implemented"
    CommonMark::Parser::Inline
    is_expected.to parse("# foo *bar* \*baz\*")
  end

  it "should ignore whitespace" do
    is_expected.to parse("##{" "*18}foo#{" "*21}")
  end

  it "should parse leading spaces" do
    is_expected.to parse("### foo")
    is_expected.to parse(" ## foo")
    is_expected.to parse("  # foo")
  end

  it "should not parse indented headers" do
    is_expected.not_to parse("    # foo")
    is_expected.not_to parse("foo\n    # bar")
  end

  it "should parse closing octothorpes" do
    is_expected.to parse("## foo ##")
    is_expected.to parse("  ###   bar    ###")
  end

  it "should parse closing sequence of different length" do
    is_expected.to parse("# foo ##################################")
    is_expected.to parse("##### foo ##")
  end

  it "should parse spaces after closing sequence" do
    is_expected.to parse("### foo ###     ")
  end

  it "should parse closing # with trailing non-space chars as content" do
    is_expected.to parse("### foo ### b")
  end

  it "should require a space before the closing sequence" do
    is_expected.to parse("# foo#")
  end

  it "should not parse escaped # as closing sequence" do
    is_expected.to parse("### foo \\###")
    is_expected.to parse("## foo #\\##")
    is_expected.to parse("# foo \\#")
  end
end
