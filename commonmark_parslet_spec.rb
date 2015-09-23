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
  it 'should parse hlines' do
    expect subject.parse('***').to eq({hline: '***'})
    expect subject.parse('---').to eq({hline: '---'})
    expect subject.parse('–––').to eq({hline: '–––'})
  end
end
