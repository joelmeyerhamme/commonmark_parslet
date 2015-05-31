require './spec/spec_helper'

describe CommonMark::Parser::LeafBlock::FencedBlock do
  it 'should consume backticks' do
    is_expected.to parse "```\nsome text\n```"
  end

  it 'should consume tildes' do
    is_expected.to parse "~~~\nsome text\n~~~"
  end

  it 'should consume two lines in backticks' do
    is_expected.to parse "```\n<\n >\n```"
  end

  it 'should consume two lines in tildes' do
    is_expected.to parse "~~~\n<\n >\n~~~"
  end

  it 'should require same closing fence as opening fence' do
    is_expected.to parse "```\naaa\n~~~\n```"
    is_expected.to parse "~~~\naaa\n```\n~~~"
  end

  it 'should require closing fence >= opening fence' do
    is_expected.to parse "````\naaa\n```\n``````"
    is_expected.to parse "~~~~\naaa\n~~~\n~~~~"
  end

  it 'should close unclosed blocks by end of document' do
    is_expected.to parse '```'
    is_expected.to parse "`````\n\n```\naaa"
  end

  it 'should consume all empty lines' do
    is_expected.to parse "```\n\n  \n```"
  end

  it 'should consume empty block' do
    is_expected.to parse "```\n```"
  end
end
