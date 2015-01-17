class CommonMark::Parser::LeafBlock::Hrule < Parslet::Parser
  root :hrule_line

  rule :hrule_line do
    pre.space_character.repeat(0,3) >> hrule >> pre.whitespace.maybe
  end

  rule :hrule do
    hrule_char("*") | hrule_char("-") | hrule_char("_")
  end

  def hrule_char(char)
    (str(char) >> pre.whitespace.maybe).repeat(3)
  end

  def pre
    @@pre ||= CommonMark::Parser::Preliminaries.new
  end
end
