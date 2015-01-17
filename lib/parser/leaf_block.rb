class CommonMark::Parser::LeafBlock < Parslet::Parser
  root(:leaf_block)

  rule(:leaf_block)
  def leaf_block
    CommonMark::Parser::LeafBlock::Hrule.new
  end
end
