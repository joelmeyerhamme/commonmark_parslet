require 'bundler'
Bundler.require(:default, :test)
require 'parslet/rig/rspec'
require 'parslet/convenience'
require 'byebug'



SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_group 'Libraries', 'lib'
  add_filter 'spec'
end

require './commonmark_parslet'

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
      expect(subject.parse(' ***')).to eq([{hrule: '***'}])
      expect(subject.parse('  ***')).to eq([{hrule: '***'}])
      expect(subject.parse('   ***')).to eq([{hrule: '***'}])
    end

    it 'should parse spaces' do
      expect(subject.parse(' - - -')).to eq([{hrule: '- - -'}])
      expect(subject.parse(' **  * ** * ** * **')).to eq([{hrule: '**  * ** * ** * **'}])
      expect(subject.parse('-     -      -      -')).to eq([{hrule: '-     -      -      -'}])
      expect(subject.parse('- - - -    ')).to eq([{hrule: '- - - -    '}])
    end
  end

  describe 'header' do
    it 'should parse atx headers' do
      expect(subject.parse('# foo')).to eq([{atx_header: {grade: '#', inline: 'foo'}}])
      expect(subject.parse('## foo')).to eq([{atx_header: {grade: '##', inline: 'foo'}}])
      expect(subject.parse('### foo')).to eq([{atx_header: {grade: '###', inline: 'foo'}}])
      expect(subject.parse('#### foo')).to eq([{atx_header: {grade: '####', inline: 'foo'}}])
      expect(subject.parse('##### foo')).to eq([{atx_header: {grade: '#####', inline: 'foo'}}])
      expect(subject.parse('###### foo')).to eq([{atx_header: {grade: '######', inline: 'foo'}}])
      expect(subject.parse('#    foo')).to eq([{atx_header: {grade: '#', inline: 'foo'}}])
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
end
