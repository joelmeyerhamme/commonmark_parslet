class CommonMark::Parser::LeafBlock < Parslet::Parser
  root :leaf_block

  rule :leaf_block do
    CommonMark::Parser::LeafBlock.new |
    CommonMark::Parser::ContainerBlock.new
  end
end
