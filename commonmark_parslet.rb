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
      rule(:character) { whitespace | punctuation | any }

      rule(:whitespace_character) do
        space | unicode_space | tab | carriage_return | newline
      end

      rule(:eol) do
        carriage_return >> newline | newline | carriage_return
      end

      rule(:whitespace) do
        whitespace_character.repeat(1)
      end

      rule(:tab)             { str("\u0009") }
      rule(:space)           { str("\u0020") }
      rule(:carriage_return) { str("\u000d") }
      rule(:bom)             { str("\u0000") }
      rule(:newline)         { str("\u000a") }
      rule(:blank_line)      { whitespace >> eol }

      rule(:non_space) { space.absent? >> any }

      rule(:ascii_punctuation) do
        str('!')  | str('"') | str('#') | str('$') | str('%') | str('&')  |
        str('\'') | str('(') | str(')') | str('*') | str('+') | str(',')  |
        str('-')  | str('.') | str('/') | str(':') | str(';') | str('<')  |
        str('=')  | str('>') | str('?') | str('@') | str('[') | str('\\') |
        str(']')  | str('^') | str('_') | str('`') | str('{') | str('|')  |
        str('}')  | str('|') | str('~')
      end

      rule(:unicode_punctuation) do
        UnicodeData::CharClass["Pc", "Pd", "Pe", "Pf", "Pi", "Po", "Ps"].
          map do |ch|
            str(ch.to_i(16).chr('utf-8'))
          end.reduce(:|)
      end

      rule(:unicode_space) do
        UnicodeData::CharClass["Zs"].map do |ch|
          str(ch.to_i(16).chr('utf-8'))
        end.reduce(:|)
      end

      rule(:punctuation) { ascii_punctuation | unicode_punctuation }
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
