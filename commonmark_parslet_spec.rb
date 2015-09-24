require './commonmark_parslet'
Bundler.require(:test)
require 'parslet/rig/rspec'
require 'parslet/convenience'

# SimpleCov.formatter = Coveralls::SimpleCov::Formatter
# SimpleCov.start do
#   add_group 'Libraries', 'lib'
#   add_filter 'spec'
# end

describe CommonMark::Parser do
  describe 'hrule' do
    it 'should parse hline with *' do
      expect(subject.parse('***')).to eq([{hrule: '***'}])
    end

    it 'should parse hline with *' do
      expect(subject.parse('---')).to eq([{hrule: '---'}])
    end

    it 'should parse hline with *' do
      expect(subject.parse('___')).to eq([{hrule: '___'}])
    end

    it 'should parse three whitespaces' do
      expect(subject.parse(' ***')).to   eq([{hrule: '***'}])
      expect(subject.parse('  ***')).to  eq([{hrule: '***'}])
      expect(subject.parse('   ***')).to eq([{hrule: '***'}])
    end

    it 'should parse spaces' do
      expect(subject.parse(' - - -')).to                eq([{hrule: '- - -'}])
      expect(subject.parse(' **  * ** * ** * **')).to   eq([{hrule: '**  * ** * ** * **'}])
      expect(subject.parse('-     -      -      -')).to eq([{hrule: '-     -      -      -'}])
      expect(subject.parse('- - - -    ')).to           eq([{hrule: '- - - -    '}])
    end
  end

  describe 'header' do
    it 'should parse atx headers' do
      expect(subject.parse('# foo')).to      eq([{atx_header: {grade: '#', inline: [{text: 'foo'}]}}])
      expect(subject.parse('## foo')).to     eq([{atx_header: {grade: '##', inline: [{text: 'foo'}]}}])
      expect(subject.parse('### foo')).to    eq([{atx_header: {grade: '###', inline: [{text: 'foo'}]}}])
      expect(subject.parse('#### foo')).to   eq([{atx_header: {grade: '####', inline: [{text: 'foo'}]}}])
      expect(subject.parse('##### foo')).to  eq([{atx_header: {grade: '#####', inline: [{text: 'foo'}]}}])
      expect(subject.parse('###### foo')).to eq([{atx_header: {grade: '######', inline: [{text: 'foo'}]}}])
      expect(subject.parse('#    foo')).to   eq([{atx_header: {grade: '#', inline: [{text: 'foo'}]}}])
    end

    it 'should parse setext headers' do
      expect(subject.parse("Foo bar\n=========")).to eq([{inline: [{text: 'Foo bar'}]}, {hrule: '========='}])
      expect(subject.parse("Foo bar\n---------")).to eq([{inline: [{text: 'Foo bar'}]}, {hrule: '---------'}])
    end
  end

  it 'should parse indented code blocks' do
    expect(subject.parse("    code block")).to eq([{indented_code: {text: 'code block'}}])
  end

  it 'should parse fenced code blocks' do
    skip 'stalling'
    expect(subject.parse("```\nhello\nworld\n```")).to eq([{fenced_code_block: "hello\nworld"}])
  end

  it 'should parse link refernce defitions' do
    expect(subject.parse('[foo]: /url "title"')).to eq([{ref_def: {ref: 'foo', destination: '/url', title: 'title'}}])
  end

  it 'should parse paragraphs' do
    expect(subject.parse('hello world')).to eq([{inline: [{text: 'hello world'}]}])
    expect(subject.parse("hello\nworld")).to eq([{inline: [{text: 'hello'}]}, {inline: [{text: 'world'}]}])
    expect(subject.parse("hello \nworld")).to eq([{inline: [{text: 'hello '}]}, {inline: [{text: 'world'}]}])
  end

  it 'should parse blank lines' do
    expect(subject.parse('  ')).to eq([{blank: '  '}])
    expect(subject.parse('   ')).to eq([{blank: '   '}])
    expect(subject.parse('    ')).to eq([{blank: '    '}])
  end

  it 'should parse block quotes' do
    expect(subject.parse('> hello world')).to eq([{quote: {inline: [{text: 'hello world'}]}}])
    expect(subject.parse("> hello world\n> hello world")).to eq([{quote: {inline: [{text: 'hello world'}]}}, {quote: {inline: [{text: 'hello world'}]}}])
  end

  it 'should parse ordered lists' do
    expect(subject.parse("1. hello\n2. world")).to eq([{ordered_list: {inline: [{text: 'hello'}]}}, {ordered_list: {inline: [{text: 'world'}]}}])
  end

  it 'should parse ordered lists' do
    expect(subject.parse("- hello\n- world")).to eq([{unordered_list: {inline: [{text: 'hello'}]}}, {unordered_list: {inline: [{text: 'world'}]}}])
  end

  it 'should parse backslash escaped characters' do
    expect(subject.parse('\!')).to eq([{inline: [{escaped: '!'}]}])
  end

  it 'should parse html entities' do
    expect(subject.parse('&amp;')).to eq([{inline: [{entity: '&amp;'}]}])
    expect(subject.parse('&#123;')).to eq([{inline: [{entity: '&#123;'}]}])
    expect(subject.parse('&#x123;')).to eq([{inline: [{entity: '&#x123;'}]}])
  end

  it 'should parse code spans' do
    expect(subject.parse('`hello world`')).to eq([{inline: [{code_span: 'hello world'}]}])
  end

  it 'should parse emphasis' do
    expect(subject.parse('*hello*')).to eq([{:inline=>[{:left_delimiter=>"*"}, {:text=>"hello"}, {:right_delimiter=>"*"}]}])
  end

  it 'should parse strong emphasis' do
    expect(subject.parse('**hello**')).to eq([{inline: [{:left_delimiter=>"**"}, {text: 'hello'}, {:right_delimiter=>"**"}]}])
  end

  it 'should parse links' do
    expect(subject.parse('[link](/uri "title")')).to eq([{inline: [{link: {text: 'link', destination: '/uri', title: 'title'}}]}])
  end

  it 'should parse links' do
    expect(subject.parse('![description](/uri \'title\')')).to eq([{inline: [{image: {description: 'description', source: '/uri', title: 'title'}}]}])
  end

  it 'should parse autolinks' do
    expect(subject.parse('<http://foo.bar.baz>')).to eq([{inline: [{link: {destination: 'http://foo.bar.baz'}}]}])
  end

  it 'should parse hard breaks' do
    expect(subject.parse('text  ')).to eq([{inline: [{text: 'text'}], hard_break: '  '}])
  end

  it 'should parse plain text' do
    expect(subject.parse('hello $.;\'there')).to    eq([{inline: [{text: "hello $.;'there"}]}])
    expect(subject.parse('Foo χρῆν')).to            eq([{inline: [{text: "Foo χρῆν"}]}])
    expect(subject.parse('Multiple     spaces')).to eq([{inline: [{text: "Multiple     spaces"}]}])
  end
end
