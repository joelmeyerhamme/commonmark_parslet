require './spec/spec_helper'

describe CommonMark::Parser::LeafBlock::Paragraph do
  it 'should consume a paragraph' do
    is_expected.to parse("aaa\n")
  end

  it 'should consume multiple lines' do
    is_expected.to parse("aaa\nbbb\n")
  end

  it 'should consume any leading spaces' do
    is_expected.to parse("  aaa\n bbb")
    is_expected.to parse("  aaa\n        bbb")
    is_expected.to parse("   aaa\n bbb")
  end

  it 'shuld not consume more than three spaces in the first line' do
    pending 'code blocks should take precedence'
    is_expected.not_to parse("    aaa\nbbb")
  end
end
