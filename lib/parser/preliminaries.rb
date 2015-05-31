class CommonMark::Parser::Preliminaries < Parslet::Parser
  ASCII_PUNCTUATION_CHARS = [
    '!', '"', '#', '$', '%', '&', '\'', '(', ')', '*', '+',
    ',', '-', '.', '/', ':', ';', '<', '=', '>', '?', '@',
    '[', '\\', ']', '^', '_', '`', '{', '|', '}', '|', '~']

  UNICODE_PUNCTUATION_CHARS = begin
    classes = ['Pc', 'Pd', 'Pe', 'Pf', 'Pi', 'Po', 'Ps']
    char_codes = UnicodeData::CharClass[*classes]
    char_codes.map { |ch| ch.to_i(16).chr('utf-8') }
  end

  UNICODE_SPACE_CHARS = begin
    char_codes = UnicodeData::CharClass['Zs']
    char_codes.map { |ch| ch.to_i(16).chr('utf-8') }
  end

  root :line

  rule :line do
    blank_line | character.repeat >> eol
  end

  rule :character do
    whitespace | punctuation | null | (eol.absent? >> any)
  end

  rule :whitespace_character do
    tab | space_character
  end

  rule :space_character do
    space | unicode_space
  end

  rule :eol do
    carriage_return >> newline | newline | carriage_return | any.absent?
  end

  rule :whitespace do
    whitespace_character.repeat(1)
  end

  rule :tab do
    str("\t") | space_character.repeat(4)
  end

  rule :space do
    str(' ')
  end

  rule :carriage_return do
    str("\r")
  end

  rule :null do
    str("\0")
  end

  rule :newline do
    str("\n")
  end

  rule :blank_line do
    whitespace.maybe >> eol
  end

  # rule :non_space do
  #   space.absent? >> any
  # end

  rule :ascii_punctuation do
    ASCII_PUNCTUATION_CHARS.map { |s| str(s) }.reduce(:|)
  end

  rule :unicode_punctuation do
    UNICODE_PUNCTUATION_CHARS.map { |ch| str(ch) }.reduce(:|)
  end

  rule :unicode_space do
    UNICODE_SPACE_CHARS.map { |ch| str(ch) }.reduce(:|)
  end

  rule :punctuation do
    ascii_punctuation | unicode_punctuation
  end

  def stri(str)
    key_chars = str.split(//)
    key_chars.
      collect! { |char| match["#{char.upcase}#{char.downcase}"] }.
      reduce(:>>)
  end
end
