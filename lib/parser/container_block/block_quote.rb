class CommonMark::Parser::ContainerBlock::BlockQuote < Parslet::Parser
  root :block_quote

  rule :block_quote do

  end

  def pre
    @pre ||= CommonMark::Parser::Preliminaries.new
  end
end
