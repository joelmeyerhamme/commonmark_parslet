class CommonMark::Parser::LeafBlock::Paragraph < Parslet::Parser
  root :paragraph

  rule :paragraph do
  end

  def pre
    @pre ||= CommonMark::Parser::Preliminaries.new
  end
end
