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

  rule(:line)
  def line
    blank_line | character.repeat >> eol
  end

  rule(:character)
  def character
    whitespace | punctuation | null | any
  end

  rule(:whitespace_character)
  def whitespace_character
    tab | space_character
  end

  rule(:space_character)
  def space_character
    space | unicode_space
  end

  rule(:eol)
  def eol
    carriage_return >> newline | newline | carriage_return | any.absent?
  end

  rule(:whitespace)
  def whitespace
    whitespace_character.repeat(1)
  end

  rule(:tab)
  def tab
    str("\t") | space_character.repeat(4)
  end

  rule(:space)
  def space
    str(" ")
  end

  rule(:carriage_return)
  def carriage_return
    str("\r")
  end

  rule(:null)
  def null
    str("\0")
  end

  rule(:newline)
  def newline
    str("\n")
  end

  rule(:blank_line)
  def blank_line
    whitespace.maybe >> eol
  end

  # # rule(:non_space)
  # def non_space
  #   space.absent? >> any
  # end

  rule(:ascii_punctuation)
  def ascii_punctuation
    self.class.ascii_punctuation_chars.map { |s| str(s) }.reduce(:|)
  end

  rule(:unicode_punctuation)
  def unicode_punctuation
    self.class.unicode_punctuation_chars.map { |ch| str(ch) }.reduce(:|)
  end

  rule(:unicode_space)
  def unicode_space
    self.class.unicode_space_chars.map { |ch| str(ch) }.reduce(:|)
  end

  rule(:punctuation)
  def punctuation
    ascii_punctuation | unicode_punctuation
  end
end
