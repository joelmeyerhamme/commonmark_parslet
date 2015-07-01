require './spec/spec_helper'

describe CommonMark::Parser::LeafBlock::BlankLine do
  it 'should consume a blank line' do
    is_expected.to parse("")
    is_expected.to parse("  ")
  end
end
