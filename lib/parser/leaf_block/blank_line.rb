class CommonMark::Parser::LeafBlock::BlankLine < Parslet::Parser
  root :blank_line

  rule :blank_line do
    pre.whitespace.repeat >> pre.eol
  end

  def pre
    @pre ||= CommonMark::Parser::Preliminaries.new
  end
end
