require './commonmark_parslet'

class CommonMark
  class Parser
    class Preliminaries < Parslet::Parser
      ASCII_PUNCTUATION ||= [
        '!', '"', '#', '$', '%', '&', '\'', '(', ')', '*', '+',
        ',', '-', '.', '/', ':', ';', '<', '=', '>', '?', '@',
        '[', '\\', ']', '^', '_', '`', '{', '|', '}', '|', '~']

      UNICODE_PUNCTUATION ||= UnicodeData::CharClass[
        "Pc", "Pd", "Pe", "Pf", "Pi", "Po", "Ps"]

      UNICODE_SPACE ||= UnicodeData::CharClass["Zs"]

      def self.unicode_punctuation
        @@unicode_punctuation ||= UNICODE_PUNCTUATION.map do |ch|
          ch.to_i(16).chr('utf-8')
        end
      end

      def self.unicode_space
        @@unicode_space ||= UNICODE_SPACE.map do |ch|
          ch.to_i(16).chr('utf-8')
        end
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
        self.class.unicode_punctuation.map { |ch| str(ch) }.reduce(:|)
      end

      rule(:unicode_space) do
        self.class.unicode_space.map { |ch| str(ch) }.reduce(:|)
      end

      rule(:punctuation) { ascii_punctuation | unicode_punctuation }
    end
  end
end
