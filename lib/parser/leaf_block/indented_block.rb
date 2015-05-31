class CommonMark::Parser::LeafBlock::IndentedBlock < Parslet::Parser
  root :indented_block

  rule :indented_block do
    chunk.repeat(1)
  end

  rule(:chunk) do
    line.repeat(1) >> ((pre.whitespace.maybe >> newline).repeat(1) | any.absent?)
  end

  rule :line do
    pre.tab >> pre.character.repeat >> pre.eol
  end

  rule :newline do
    str("\n")
  end

  def pre
    @pre ||= CommonMark::Parser::Preliminaries.new
  end
end
