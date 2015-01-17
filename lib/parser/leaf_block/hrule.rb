class CommonMark::Parser::LeafBlock::Hrule < Parslet::Parser
  root(:hrule_line)

  def hrule_line_def
    space_character.repeat(0,3) >> (hrule) >> whitespace.maybe
  end; rule(:hrule_line) { hrule_line_def }

  def hrule_def
    hrule_char("*") | hrule_char("-") | hrule_char("_")
  end; rule(:hrule) { hrule_def }

  def hrule_char(char)
    (str(char) >> whitespace.maybe).repeat(3)
  end

  def whitespace_def
    CommonMark::Parser::Preliminaries.new.whitespace
  end; rule(:whitespace) { whitespace_def }

  def space_character_def
    CommonMark::Parser::Preliminaries.new.space_character
  end; rule(:space_character) { space_character_def }
end
