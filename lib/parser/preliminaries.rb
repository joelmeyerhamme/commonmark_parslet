class CommonMark::Parser::Preliminaries < Parslet::Parser
  def self.ascii_punctuation_chars
    @@ascii_punctuation ||= [
      '!', '"', '#', '$', '%', '&', '\'', '(', ')', '*', '+',
      ',', '-', '.', '/', ':', ';', '<', '=', '>', '?', '@',
      '[', '\\', ']', '^', '_', '`', '{', '|', '}', '|', '~' ]
  end

  def self.unicode_punctuation_chars
    @@unicode_punctuation ||= begin
      classes = ["Pc", "Pd", "Pe", "Pf", "Pi", "Po", "Ps"]
      char_codes = UnicodeData::CharClass[*classes]
      char_codes.map { |ch| ch.to_i(16).chr('utf-8') }
    end
  end

  def self.unicode_space_chars
    @@unicode_space ||= begin
      char_codes = UnicodeData::CharClass["Zs"]
      char_codes.map { |ch| ch.to_i(16).chr('utf-8') }
    end
  end

  root(:line)

  def line_def
    blank_line | character.repeat >> eol
  end; rule(:line) { line_def }

  def character_def
    whitespace | punctuation | null | any
  end; rule(:character) { character_def }

  def whitespace_character_def
    tab | space_character
  end; rule(:whitespace_character) { whitespace_character_def }

  def space_character_def
    space | unicode_space
  end; rule(:space_character) { space_character_def }

  def eol_def
    carriage_return >> newline | newline | carriage_return | any.absent?
  end; rule(:eol) { eol_def }

  def whitespace_def
    whitespace_character.repeat(1)
  end; rule(:whitespace) { whitespace_def }

  def tab_def
    str("\t") | space_character.repeat(4)
  end; rule(:tab) { tab_def }

  def space_def
    str(" ")
  end; rule(:space) { space_def }

  def carriage_return_def
    str("\r")
  end; rule(:carriage_return) { carriage_return_def }

  def null_def
    str("\0")
  end; rule(:null) { null_def }

  def newline_def
    str("\n")
  end; rule(:newline) { newline_def }

  def blank_line_def
    whitespace.maybe >> eol
  end; rule(:blank_line) { blank_line_def }

  # def non_space_def
  #   space.absent? >> any
  # end; rule(:non_space) { non_space_def }

  def ascii_punctuation_def
    self.class.ascii_punctuation_chars.map { |s| str(s) }.reduce(:|)
  end; rule(:ascii_punctuation) { ascii_punctuation_def }

  def unicode_punctuation_def
    self.class.unicode_punctuation_chars.map { |ch| str(ch) }.reduce(:|)
  end; rule(:unicode_punctuation) { unicode_punctuation_def }

  def unicode_space_def
    self.class.unicode_space_chars.map { |ch| str(ch) }.reduce(:|)
  end; rule(:unicode_space) { unicode_space_def }

  def punctuation_def
    ascii_punctuation | unicode_punctuation
  end; rule(:punctuation) { punctuation_def }
end
