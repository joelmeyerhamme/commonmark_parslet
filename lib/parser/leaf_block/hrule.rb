class CommonMark::Parser::LeafBlock::Hrule < Parslet::Parser
  root(:hrule_line)

  # rule(:hrule_line)
  def hrule_line
    space_character.repeat(0,3) >> (hrule) >> whitespace.maybe
  end

  # rule(:hrule)
  def hrule
    hrule_char("*") | hrule_char("-") | hrule_char("_")
  end

  # rule(:hrule_char)
  def hrule_char(char)
    (str(char) >> whitespace.maybe).repeat(3)
  end

  # rule(:whitespace)
  def whitespace
    CommonMark::Parser::Preliminaries.new.whitespace
  end

  # rule(:space_character)
  def space_character
    CommonMark::Parser::Preliminaries.new.space_character
  end
end
