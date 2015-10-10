require './spec/spec_helper'

describe CommonMark::Parser do
  describe 'hrule' do
    it 'should parse hline with *' do
      expect(subject.parse('***')).to eq({document: [{hrule: '***'}]})
    end

    it 'should parse hline with *' do
      expect(subject.parse('---')).to eq({document: [{hrule: '---'}]})
    end

    it 'should parse hline with *' do
      expect(subject.parse('___')).to eq({document: [{hrule: '___'}]})
    end

    it 'should parse upto three whitespaces' do
      expect(subject.parse(' ***')).to eq({document: [{hrule: '***'}]})
      expect(subject.parse('  ***')).to eq({document: [{hrule: '***'}]})
      expect(subject.parse('   ***')).to eq({document: [{hrule: '***'}]})
    end

    it 'should parse spaces' do
      expect(subject.parse(' - - -')).to eq(
        {document: [{hrule: '- - -'}]})
      expect(subject.parse(' **  * ** * ** * **')).to eq(
        {document: [{hrule: '**  * ** * ** * **'}]})
      expect(subject.parse('-     -      -      -')).to eq(
        {document: [{hrule: '-     -      -      -'}]})
      expect(subject.parse('- - - -    ')).to eq(
        {document: [{hrule: '- - - -    '}]})
    end
  end

  describe 'header' do
    it 'should parse atx headers' do
      expect(subject.parse('# foo')).to eq(
        {document: [{atx_header: {grade: '#', inline: [{text: 'foo'}]}}]})
      expect(subject.parse('## foo')).to eq(
        {document: [{atx_header: {grade: '##', inline: [{text: 'foo'}]}}]})
      expect(subject.parse('### foo')).to eq(
        {document: [{atx_header: {grade: '###', inline: [{text: 'foo'}]}}]})
      expect(subject.parse('#### foo')).to eq(
        {document: [{atx_header: {grade: '####', inline: [{text: 'foo'}]}}]})
      expect(subject.parse('##### foo')).to eq(
        {document: [{atx_header: {grade: '#####', inline: [{text: 'foo'}]}}]})
      expect(subject.parse('###### foo')).to eq(
        {document: [{atx_header: {grade: '######', inline: [{text: 'foo'}]}}]})
      expect(subject.parse('#    foo')).to eq(
        {document: [{atx_header: {grade: '#', inline: [{text: 'foo'}]}}]})
    end

    it 'should parse setext headers' do
      expect(subject.parse("Foo bar\n=========")).to eq(
        {document: [{setext_header:
          {inline: [{text: 'Foo bar'}], grade_1: '========='}}]})
      expect(subject.parse("Foo bar\n---------")).to eq(
        {document: [{setext_header:
          {inline: [{text: 'Foo bar'}], grade_2: '---------'}}]})
    end
  end

  it 'should parse indented code blocks' do
    expect(subject.parse("    code block")).to eq(
      {document: [{indented_code: {text: 'code block'}}]})
  end

  it 'should parse fenced code blocks' do
    expect(subject.parse("```\nhello\nworld\n```")).to eq(
      {document: [{fenced_code_block: [{text: "hello"}, {text: "world"}]}]})
  end

  it 'should parse link refernce defitions' do
    expect(subject.parse('[foo]: /url "title"')).to eq(
      {document: [{ref_def: {ref: 'foo', destination: '/url', title: 'title'}}]})
  end

  it 'should parse paragraphs' do
    expect(subject.parse('hello world')).to eq(
      {document: [{inline: [{text: 'hello world'}]}]})
    expect(subject.parse("hello\nworld")).to eq(
      {document: [{inline: [{text: 'hello'}]}, {inline: [{text: 'world'}]}]})
    expect(subject.parse("hello \nworld")).to eq(
      {document: [{inline: [{text: 'hello '}]}, {inline: [{text: 'world'}]}]})
  end

  describe 'should parse blank lines' do
    it 'should parse spaces' do
      expect(subject.parse('  ')).to   eq({document: [{blank: '  '}]})
      expect(subject.parse('   ')).to  eq({document: [{blank: '   '}]})
      expect(subject.parse('    ')).to eq({document: [{blank: '    '}]})
    end

    it 'should parse empty lines with newline' do
      pending 'newlines not implemented'
      expect(subject.parse("\n")).to eq({document: [{blank: ''}]})
      expect(subject.parse("hello\n\nworld")).to eq({document: [{blank: '    '}]})
    end
  end

  it 'should parse block quotes' do
    expect(subject.parse('> hello world')).to eq(
      {document: [{quote: {inline: [{text: 'hello world'}]}}]})
    expect(subject.parse("> hello world\n> hello world")).to eq(
      {document: [
        {quote: {inline: [{text: 'hello world'}]}},
        {quote: {inline: [{text: 'hello world'}]}}]})
  end

  it 'should parse ordered lists' do
    expect(subject.parse("1. hello\n2. world")).to eq(
      {document: [
        {ordered_list: {inline: [{text: 'hello'}]}},
        {ordered_list: {inline: [{text: 'world'}]}}]})
  end

  it 'should parse ordered lists' do
    pending 'implement newlines'
    expect(subject.parse("- hello\n- world")).to eq(
      {document: [
        {unordered_list: {inline: [{text: 'hello'}]}},
        {unordered_list: {inline: [{text: 'world'}]}}]})
  end

  it 'should parse backslash escaped characters' do
    expect(subject.parse('\!')).to eq({document: [{inline: [{escaped: '!'}]}]})
  end

  it 'should parse html entities' do
    expect(subject.parse('&amp;')).to eq(
      {document: [{inline: [{entity: '&amp;'}]}]})
    expect(subject.parse('&#123;')).to eq(
      {document: [{inline: [{entity: '&#123;'}]}]})
    expect(subject.parse('&#x123;')).to eq(
      {document: [{inline: [{entity: '&#x123;'}]}]})
  end

  it 'should parse code spans' do
    expect(subject.parse('`hello world`')).to eq(
      {document: [{inline: [{code_span: 'hello world'}]}]})
  end

  it 'should parse emphasis' do
    expect(subject.parse('*hello*')).to eq({document: [{:inline=>[
      {:left_delimiter=>"*"}, {:text=>"hello"}, {:right_delimiter=>"*"}]}]})
  end

  it 'should parse strong emphasis' do
    expect(subject.parse('**hello**')).to eq({document: [{inline: [{
      :left_delimiter=>"**"}, {text: 'hello'}, {:right_delimiter=>"**"}]}]})
  end

  it 'should parse links' do
    expect(subject.parse('[link](/uri "title")')).to eq({document: [{inline: [{
      link: {text: 'link', destination: '/uri', title: 'title'}}]}]})
  end

  it 'should parse links' do
    expect(subject.parse('![description](/uri \'title\')')).to eq({document: [{inline: [{
      image: {description: 'description', source: '/uri', title: 'title'}}]}]})
  end

  it 'should parse autolinks' do
    expect(subject.parse('<http://foo.bar.baz>')).to eq(
      {document: [{inline: [{link: {destination: 'http://foo.bar.baz'}}]}]})
  end

  it 'should parse hard breaks' do
    expect(subject.parse('text  ')).to eq(
      {document: [{inline: [{text: 'text'}], hard_break: '  '}]})
  end

  it 'should parse plain text' do
    expect(subject.parse('hello $.;\'there')).to eq(
      {document: [{inline: [{text: "hello $.;'there"}]}]})
    expect(subject.parse('Foo χρῆν')).to eq(
      {document: [{inline: [{text: "Foo χρῆν"}]}]})
    expect(subject.parse('Multiple     spaces')).to eq(
      {document: [{inline: [{text: "Multiple     spaces"}]}]})
  end
end

describe CommonMark::HtmlTransform do

  let!(:parser) { CommonMark::Parser.new }

  describe 'hrule' do
    it 'should parse hline with *' do
      expect(subject.apply({document: [{hrule: '***'}]})).to eq('<hr />')
    end

    it 'should parse hline with *' do
      expect(subject.apply({document: [{hrule: '---'}]})).to eq('<hr />')
    end

    it 'should parse hline with *' do
      expect(subject.apply({document: [{hrule: '___'}]})).to eq('<hr />')
    end

    it 'should parse upto three whitespaces' do
      expect(subject.apply({document: [{hrule: '***'}]})).to eq('<hr />')
      expect(subject.apply({document: [{hrule: '***'}]})).to eq('<hr />')
      expect(subject.apply({document: [{hrule: '***'}]})).to eq('<hr />')
    end

    it 'should parse spaces' do
      expect(subject.apply({document: [{hrule: '- - -'}]})).
        to eq('<hr />')
      expect(subject.apply({document: [{hrule: '**  * ** * ** * **'}]})).
        to eq('<hr />')
      expect(subject.apply({document: [{hrule: '-     -      -      -'}]})).
        to eq('<hr />')
      expect(subject.apply({document: [{hrule: '- - - -    '}]})).
        to eq('<hr />')
    end
  end

  describe 'headers' do
    it 'should parse atx header of first degree' do
      expect(subject.apply({document: [{atx_header:
        {grade: '#', inline: [{text: 'foo'}]}}]})).to eq('<h1>foo</h1>')
    end

    it 'should parse header of 2nd degre' do
      expect(subject.apply({document: [{atx_header:
        {grade: '##', inline: [{text: 'foo'}]}}]})).to eq('<h2>foo</h2>')
    end

    it 'should parse header of 3rd degre' do
      expect(subject.apply({document: [{atx_header:
        {grade: '###', inline: [{text: 'foo'}]}}]})).to eq('<h3>foo</h3>')
    end

    it 'should parse header of 4th degre' do
      expect(subject.apply({document: [{atx_header:
        {grade: '####', inline: [{text: 'foo'}]}}]})).to eq('<h4>foo</h4>')
    end

    it 'should parse header of 5th degre' do
      expect(subject.apply({document: [{atx_header:
        {grade: '#####', inline: [{text: 'foo'}]}}]})).to eq('<h5>foo</h5>')
    end

    it 'should parse header of 6th degre' do
      expect(subject.apply({document: [{atx_header:
        {grade: '######', inline: [{text: 'foo'}]}}]})).to eq('<h6>foo</h6>')
    end

    it 'should parse setext header of first grade' do
      skip 'implement delimeters'
      expect(subject.apply(parser.parse "Foo *bar*\n=========")).to eq(
        '<h1>Foo <em>bar</em></h1>')
    end

    it 'should parse setext header of second grade' do
      skip 'implement delimeters'
      expect(subject.apply(parser.parse "Foo *bar*\n---------")).to eq(
        '<h2>Foo <em>bar</em></h2>')
    end

    it 'should parse setext header of first grade' do
      expect(subject.apply(parser.parse "Foo bar\n=========")).to eq(
        '<h1>Foo bar</h1>')
    end

    it 'should parse setext header of second grade' do
      expect(subject.apply(parser.parse "Foo bar\n---------")).to eq(
        '<h2>Foo bar</h2>')
    end
  end
end
