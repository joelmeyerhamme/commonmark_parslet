require './commonmark_parslet'

class CommonMark::Parser::Preliminaries < Parslet::Parser
  def ascii_punctuation_chars
    @@ascii_punctuation ||= [
      '!', '"', '#', '$', '%', '&', '\'', '(', ')', '*', '+',
      ',', '-', '.', '/', ':', ';', '<', '=', '>', '?', '@',
      '[', '\\', ']', '^', '_', '`', '{', '|', '}', '|', '~' ]
  end

  def unicode_punctuation_chars
    @@unicode_punctuation ||= begin
      classes = ["Pc", "Pd", "Pe", "Pf", "Pi", "Po", "Ps"]
      char_codes = UnicodeData::CharClass[*classes]
      char_codes.map { |ch| ch.to_i(16).chr('utf-8') }
    end
  end

  def unicode_space_chars
    @@unicode_space ||= begin
      char_codes = UnicodeData::CharClass["Zs"]
      char_codes.map { |ch| ch.to_i(16).chr('utf-8') }
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
    ascii_punctuation_chars.map { |s| str(s) }.reduce(:|)
  end

  rule(:unicode_punctuation) do
    unicode_punctuation_chars.map { |ch| str(ch) }.reduce(:|)
  end

  rule(:unicode_space) do
    unicode_space_chars.map { |ch| str(ch) }.reduce(:|)
  end

  rule(:punctuation) { ascii_punctuation | unicode_punctuation }
end
