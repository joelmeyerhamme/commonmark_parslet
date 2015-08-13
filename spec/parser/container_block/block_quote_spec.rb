require './spec/spec_helper'

describe CommonMark::Parser::ContainerBlock::BlockQuote do
  it 'should consume a simple block quote' do
    is_expected.to parse("> # Foo\n> bar\n> baz")
  end

  it 'should not require spaces after quote char' do
    is_expected.to parse("># Foo\n>bar\n> baz")
  end

  it 'should consume up to 3 spaces indentation' do
    is_expected.to parse("   > # Foo\n   > bar\n > baz")
  end

  it 'should not consume four trailing spaces' do
    is_expected.to parse("    > # Foo\n    > bar\n    > baz")
  end

  it 'should consume lazy quotes' do
    pending 'container blocks content types not implemented'
    is_expected.to parse("> # Foo\n> bar\nbaz")
  end

  it 'should consume mixed lazy quotes' do
    pending 'container blocks content types not implemented'
    is_expected.to parse("> bar\nbaz\n> foo")
  end

  it 'should not consume lazy non continuation lines' do
    # pending 'container blocks content types not implemented'
    is_expected.not_to parse("> foo\n---")
    is_expected.not_to parse(">     foo\n    bar")
  end

  it 'should consume empty blockquotes' do
    is_expected.to parse('>')
    is_expected.to parse(">\n>  \n> ")
  end

  it 'should consume leading and trailing quoted blank lines' do
    is_expected.to parse(">\n> foo\n>  ")
  end

  it 'should not consume blank lines' do
    is_expected.not_to parse("> foo\n\n> bar")
  end

  it 'should not require blank lines' do
    is_expected.not_to parse("> aaa\n***\n> bbb")
  end
end
