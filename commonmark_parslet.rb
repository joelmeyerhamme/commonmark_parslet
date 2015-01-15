require 'parslet'
require 'rspec'
require 'parslet/rig/rspec'
require './unicode_data'

require 'byebug'

class CommonMark
  class Parser
    class Preliminaries < Parslet::Parser
      root(:line)

      rule(:line) { character.repeat }
      rule(:character) { whitespace | any }

      rule(:whitespace_character) do
        space | tab | newline
      end

      rule(:whitespace) do
        whitespace_character.repeat(1)
      end

      rule(:tab)             { str("\u0009") }
      rule(:space)           { str("\u0020") }
      rule(:newline)         { str("\u000a") }
    end
  end

  class Transform
    class HTML < Parslet::Transform
    end
  end
end


describe CommonMark::Parser::Preliminaries do
  subject do
    described_class.new
  end

  it "should parse anything at all" do
    expect(subject).to parse(".")
  end

  it "should parse whitespace" # do
    # pending "freeze"
    # expect(subject).to parse("\u0009")
    # expect(subject).to parse("\u0020")
    # expect(subject).to parse("\u000d")
    # expect(subject).to parse("\u0000")
    # expect(subject).to parse("\u000a")
  # end

  it "should parse ascii punctuation" # do
    # pending "freeze"
    # expect(subject).to parse('!')
    # expect(subject).to parse('"')
    # expect(subject).to parse('#')
    # expect(subject).to parse('$')
    # expect(subject).to parse('%')
    # expect(subject).to parse('&')
    # expect(subject).to parse('\'')
    # expect(subject).to parse('(')
    # expect(subject).to parse(')')
    # expect(subject).to parse('*')
    # expect(subject).to parse('+')
    # expect(subject).to parse(',')
    # expect(subject).to parse('-')
    # expect(subject).to parse('.')
    # expect(subject).to parse('/')
    # expect(subject).to parse(':')
    # expect(subject).to parse(';')
    # expect(subject).to parse('<')
    # expect(subject).to parse('=')
    # expect(subject).to parse('>')
    # expect(subject).to parse('?')
    # expect(subject).to parse('@')
    # expect(subject).to parse('[')
    # expect(subject).to parse('\\')
    # expect(subject).to parse(']')
    # expect(subject).to parse('^')
    # expect(subject).to parse('_')
    # expect(subject).to parse('`')
    # expect(subject).to parse('{')
    # expect(subject).to parse('|')
    # expect(subject).to parse('}')
    # expect(subject).to parse('|')
    # expect(subject).to parse('~')
  # end

  it "should parse unicode whitespace"
  it "should parse unicode punctuation"
end

describe CommonMark::Transform::HTML do
end
