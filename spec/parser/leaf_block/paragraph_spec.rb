require './spec/spec_helper'

describe CommonMark::Parser::LeafBlock::Paragraph do
  it 'should consume a paragraph' do
    is_expected.to parse('')
  end
end
