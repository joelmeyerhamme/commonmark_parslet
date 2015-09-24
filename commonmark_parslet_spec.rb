require './commonmark_parslet'
Bundler.require(:test)
require 'parslet/rig/rspec'
require 'parslet/convenience'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_group 'Libraries', 'lib'
  add_filter 'spec'
end


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
      expect(subject.parse('# foo')).to      eq([{atx_header: {grade: '#', inline: 'foo'}}])
      expect(subject.parse('## foo')).to     eq([{atx_header: {grade: '##', inline: 'foo'}}])
      expect(subject.parse('### foo')).to    eq([{atx_header: {grade: '###', inline: 'foo'}}])
      expect(subject.parse('#### foo')).to   eq([{atx_header: {grade: '####', inline: 'foo'}}])
      expect(subject.parse('##### foo')).to  eq([{atx_header: {grade: '#####', inline: 'foo'}}])
      expect(subject.parse('###### foo')).to eq([{atx_header: {grade: '######', inline: 'foo'}}])
      expect(subject.parse('#    foo')).to   eq([{atx_header: {grade: '#', inline: 'foo'}}])
    end

    it 'should parse setext headers' do
      skip 'multi line'
      expect(subject.parse("Foo *bar*\n=========")).to eq([{setext_header: {inline: 'Foo *bar*', grade: '========='}}])
      expect(subject.parse("Foo *bar*\n---------")).to eq([{setext_header: {inline: 'Foo *bar*', grade: '---------'}}])
    end
  end

  it 'should parse indented code blocks' do
    expect(subject.parse("    code block")).to eq([{indented_code: 'code block'}])
  end

  it 'should parse fenced code blocks' do
    skip 'stalling'
    expect(subject.parse("```\nhello\nworld\n```")).to eq([{fenced_code_block: "hello\nworld"}])
  end

  it 'should parse link refernce defitions' do
    expect(subject.parse('[foo]: /url "title"')).to eq([{ref_def: {ref: 'foo', link: '/url', title: 'title'}}])
  end

  it 'should parse paragraphs' do
    expect(subject.parse('hello world')).to eq([{inline: 'hello world'}])
    expect(subject.parse("hello\nworld")).to eq([{inline: 'hello'}, {inline: 'world'}])
  end

  it 'should parse blank lines' do
    # expect(subject.parse('')).to   eq([{blank: ''}]) # empty document
    expect(subject.parse('  ')).to eq([{blank: '  '}])
  end

  it 'should parse block quotes' do
    expect(subject.parse('> hello world')).to eq([{quote: {inline: 'hello world'}}])
    expect(subject.parse("> hello world\n> hello world")).to eq([{quote: {inline: 'hello world'}}, {quote: {inline: 'hello world'}}])
  end

  it 'should parse ordered lists' do
    expect(subject.parse("1. hello\n2. world")).to eq([{ordered_list: {inline: 'hello'}}, {ordered_list: {inline: 'world'}}])
  end

  it 'should parse ordered lists' do
    expect(subject.parse("- hello\n- world")).to eq([{unordered_list: {inline: 'hello'}}, {unordered_list: {inline: 'world'}}])
  end

  it 'should parse backslash escaped characters' do
    expect(subject.parse('\!')).to eq([{inline: {escaped: '!'}}])
  end

  it 'should parse html entities' do
    expect(subject.parse('&amp;')).to eq([{inline: {entity: '&amp;'}}])
    expect(subject.parse('&#123;')).to eq([{inline: {entity: '&#123;'}}])
    expect(subject.parse('&#x123;')).to eq([{inline: {entity: '&#x123;'}}])
  end
end
