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

  def line
    character.repeat
  end

  def character
    whitespace | punctuation | any
  end

  def whitespace_character
    space | unicode_space | tab | carriage_return | newline
  end

  def eol
    carriage_return >> newline | newline | carriage_return
  end

  def whitespace
    whitespace_character.repeat(1)
  end

  def tab
    str("\t")
  end

  def space
    str(" ")
  end

  def carriage_return
    str("\r")
  end

  def null
    str("\0")
  end

  def newline
    str("\n")
  end

  def blank_line
    whitespace >> eol
  end

  def non_space
    space.absent? >> any
  end

  def ascii_punctuation
    self.class.ascii_punctuation_chars.map { |s| str(s) }.reduce(:|)
  end

  def unicode_punctuation
    self.class.unicode_punctuation_chars.map { |ch| str(ch) }.reduce(:|)
  end

  def unicode_space
    self.class.unicode_space_chars.map { |ch| str(ch) }.reduce(:|)
  end

  rule(:punctuation) { ascii_punctuation | unicode_punctuation }
end
