require 'rubygems'
require 'bundler'

Bundler.require(:default, :test)

require 'parslet/rig/rspec'
require './unicode_data'

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

class CommonMark
  class Parser
    class Preliminaries < Parslet::Parser
      ASCII_PUNCTUATION ||= [
        '!', '"', '#', '$', '%', '&', '\'', '(', ')', '*', '+',
        ',', '-', '.', '/', ':', ';', '<', '=', '>', '?', '@',
        '[', '\\', ']', '^', '_', '`', '{', '|', '}', '|', '~']

      UNICODE_PUNCTUATION ||= UnicodeData::CharClass[
        "Pc", "Pd", "Pe", "Pf", "Pi", "Po", "Ps"].map do |ch|
        ch.to_i(16).chr('utf-8')
      end

      UNICODE_SPACE ||= UnicodeData::CharClass["Zs"].map do |ch|
        ch.to_i(16).chr('utf-8')
      end

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

      rule(:tab)             { str("\t") }
      rule(:space)           { str(" ")  }
      rule(:carriage_return) { str("\r") }
      rule(:null)            { str("\0") }
      rule(:newline)         { str("\n") }
      rule(:blank_line)      { whitespace >> eol }

      rule(:non_space) { space.absent? >> any }

      rule(:ascii_punctuation) do
        ASCII_PUNCTUATION.map { |s| str(s) }.reduce(:|)
      end

      rule(:unicode_punctuation) do
        UNICODE_PUNCTUATION.
          map { |ch| str(ch) }.reduce(:|)
      end

      rule(:unicode_space) do
        UNICODE_SPACE.map { |ch| str(ch) }.reduce(:|)
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
  it "should parse whitespace" do
    is_expected.to parse("\t")
    is_expected.to parse(" ")
    is_expected.to parse("\r")
    is_expected.to parse("\0")
    is_expected.to parse("\n")
  end

  it "should parse ascii punctuation" do
    CommonMark::Parser::Preliminaries::ASCII_PUNCTUATION.each do |p|
      is_expected.to parse(p)
    end
  end

  it "should parse unicode whitespace" do
    CommonMark::Parser::Preliminaries::UNICODE_SPACE.each do |ch|
      is_expected.to parse(ch)
    end
  end

  it "should parse unicode punctuation" do
    CommonMark::Parser::Preliminaries::UNICODE_PUNCTUATION.each do |ch|
      is_expected.to parse(ch)
    end
  end
end

describe CommonMark::Transform::HTML do
end
