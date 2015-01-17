class CommonMark::Parser::LeafBlock::Hrule < Parslet::Parser
  root(:hrule_line)

  def hrule_line_def
    space_character.repeat(0,3) >> (hrule) >> whitespace.maybe
  end
  rule(:hrule_line) { hrule_line_def }

  def hrule
    hrule_char("*") | hrule_char("-") | hrule_char("_")
  end

  def hrule_char(char)
    (str(char) >> whitespace.maybe).repeat(3)
  end

  def whitespace
    CommonMark::Parser::Preliminaries.new.whitespace
  end

  def space_character
    CommonMark::Parser::Preliminaries.new.space_character
  end
end
