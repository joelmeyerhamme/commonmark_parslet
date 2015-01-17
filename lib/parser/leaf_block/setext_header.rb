class CommonMark::Parser::LeafBlock::SetextHeader < Parslet::Parser
  root :setext_header

  rule :setext_header do
    header("=") | header("-")
  end

  def header char
    leading_space >> inline >> whitespace.maybe >> eol >>
    leading_space >> underline(char) >> whitespace.maybe >> eol
  end

  def underline char
    str(char).repeat(1)
  end

  rule :inline do
    pre.character.repeat(1)
  end

  rule :leading_space do
    pre.space_character.repeat(0,3)
  end

  rule :whitespace do
    pre.whitespace
  end

  rule :eol do
    pre.eol
  end

  def pre
    @@pre ||= CommonMark::Parser::Preliminaries.new
  end
end
