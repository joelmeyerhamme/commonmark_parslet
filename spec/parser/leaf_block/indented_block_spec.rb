require './spec/spec_helper'

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

  it "should consume a one line code bock" do
    is_expected.to parse "    this is code"
  end

  it "should consume a single code chunk" do
    is_expected.to parse "    this is\n    code"
  end

  it "should consume multiple code chunks" do
    is_expected.to parse \
      "\tthis is\n\tcode\n\n\tand\n\tso on"
  end

  it "should consume anything" do
    is_expected.to parse \
      "\tlorem\n\tipsum\n\n\tdolor\n\tsit\n\tamet"
  end

  it "should consume simple code blocks" do
    is_expected.to parse \
      "    a simple\n    indented code block"
  end

  it "should consume literally" do
    is_expected.to parse \
      "    <a/>\n    *hi*\n\n    - one"
  end

  it "should consume multiple chunks" do
    is_expected.to parse \
      "    chunk1\n\n\tchunk2\n  \n \n \n    chunk3"
  end

  it "should consume multiple chunks" do
    is_expected.to parse \
      "    chunk1\n\n\tchunk2\n  \n    chunk3"
  end

  it "should consume excess spaces literally" do
    is_expected.to parse "    chunk1\n      \n      chunk2"
  end

  context "chunk" do
    subject { described_class.new.chunk }

    it "should parse intented blocks without blank lines" do
      is_expected.to parse("    chunk")
      is_expected.to parse("    hello\n    world")
      is_expected.not_to parse("    hello\n\n    world")
    end
  end

  context "line" do
    subject { described_class.new.line }

    it "should consume mostly anything" do
      is_expected.to parse "    hello world"
    end

    it "should consume newlines" do
      is_expected.to parse "\thello world\n"
    end

    it "should not consume more than one line" do
      is_expected.not_to parse "\thello\n\tworld\n"
    end
  end
end
