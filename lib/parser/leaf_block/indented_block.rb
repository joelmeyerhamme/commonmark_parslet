class CommonMark::Parser::LeafBlock::IndentedBlock < Parslet::Parser
  root :indented_block

  rule :indented_block do
    chunk.repeat(1)
  end

  rule(:chunk) do
    (pre.blank_line.absent? >> line).repeat(1) >> pre.blank_line
  end

  rule :line do
    pre.tab >> pre.line
  end

  def pre
    @@pre ||= CommonMark::Parser::Preliminaries.new
  end
end
