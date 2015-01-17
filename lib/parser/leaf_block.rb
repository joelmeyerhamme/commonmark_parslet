class CommonMark::Parser::LeafBlock < Parslet::Parser
  root :leaf_block

  rule :leaf_block do
    CommonMark::Parser::LeafBlock::AtxHeader.new |
    CommonMark::Parser::LeafBlock::Hrule.new
  end
end
