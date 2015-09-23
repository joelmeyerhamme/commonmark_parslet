require 'bundler'
Bundler.require(:default, :test)
require 'parslet/rig/rspec'
require 'parslet/convenience'



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

    it 'should not parse hline with two or different characters' do
      expect(subject).not_to parse('--')
      expect(subject).not_to parse('**')
      expect(subject).not_to parse('__')
      expect(subject).not_to parse('*-*')
    end

    it 'should parse three whitespaces' do
      expect(subject.parse(' ***')).to eq([{hrule: '***'}])
      expect(subject.parse('  ***')).to eq([{hrule: '***'}])
      expect(subject.parse('   ***')).to eq([{hrule: '***'}])
      expect(subject).not_to parse('    ***')
    end

    it 'should parse spaces' do
      expect(subject.parse(' - - -')).to eq([{hrule: '- - -'}])
      expect(subject.parse(' **  * ** * ** * **')).to eq([{hrule: '**  * ** * ** * **'}])
      expect(subject.parse('-     -      -      -')).to eq([{hrule: '-     -      -      -'}])
      expect(subject.parse('- - - -    ')).to eq([{hrule: '- - - -    '}])
      expect(subject).not_to parse('_ _ _ _ a')
      expect(subject).not_to parse('a------')
      expect(subject).not_to parse('---a---')
    end
  end
end
