class CommonMark::Parser::LeafBlock < Parslet::Parser
  root :leaf_block

  rule :leaf_block do
    CommonMark::Parser::LeafBlock::AtxHeader.new |
    CommonMark::Parser::LeafBlock::SetextHeader.new |
    CommonMark::Parser::LeafBlock::Hrule.new
    CommonMark::Parser::LeafBlock::FencedBlock.new |
    CommonMark::Parser::LeafBlock::HtmlBlock.new |
    CommonMark::Parser::LeafBlock::IndentedBlock.new |
    CommonMark::Parser::LeafBlock::LinkReferenceDefinition.new |
    CommonMark::Parser::LeafBlock::Paragraph.new
  end
end
