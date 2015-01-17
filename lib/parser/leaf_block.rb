class CommonMark::Parser::LeafBlock < Parslet::Parser
  root(:leaf_block)

  def leaf_block_def
    CommonMark::Parser::LeafBlock::Hrule.new
  end; rule(:leaf_block) { leaf_block_def }
end
