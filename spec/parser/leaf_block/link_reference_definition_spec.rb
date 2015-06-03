require './spec/spec_helper'

describe CommonMark::Parser::LeafBlock::LinkReferenceDefinition do
  it 'should consume link reference definition' do
    is_expected.to parse('[foo]: /url "title"')
  end

  it 'should consume whitespace' do
    is_expected.to parse("   [foo]: \n      /url  \n           'the title'  ")
  end

  it 'should consume any chars' do
    is_expected.to parse('[Foo*bar\]]:my_(url) \'title (with parens)\'')
  end

  it 'should consume multiple lines' do
    is_expected.to parse("[Foo bar]:\n<my url>\n\'title\'")
  end

  it 'should consume multiline titles' do
    is_expected.to parse("[foo]: /url '\ntitle\nline1\nline2\n'")
  end

  it 'should not consume blank lines' do
    is_expected.to parse("[foo]: /url 'title\n\nwith blank line'")
  end

  it 'should not require a title' do
    is_expected.to parse("[foo]:\n/url")
  end

  it 'should require a link destination' do
    is_expected.not_to parse('[foo]:')
  end

  it 'should not consume trailing input' do
    is_expected.not_to parse('[foo]: /url "title" ok')
  end

  it 'should not consume indentation' do
    is_expected.not_to parse('    [foo]: /url "title"')
  end

  it 'should parse multiple definitions' do
    is_expected.to parse("[foo]: /foo-url \"foo\"\n[bar]: /bar-url\n  \"bar\"\n[baz]: /baz-url")
  end
end
