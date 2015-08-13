class CommonMark::Parser::ContainerBlock < Parslet::Parser
  root :leaf_block

  rule :leaf_block do
    CommonMark::Parser::ContainerBlock::BlockQuote.new
  end
end
