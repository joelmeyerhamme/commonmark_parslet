class CommonMark::Parser::LeafBlock::Paragraph < Parslet::Parser
  root :paragraph

  rule :paragraph do
    (pre.newline.repeat(2).absent? >> any).repeat(1)
  end

  def pre
    @pre ||= CommonMark::Parser::Preliminaries.new
  end
end
