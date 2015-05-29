class CommonMark::Parser::LeafBlock::FencedBlock < Parslet::Parser
  root :fenced_block

  rule :fenced_block do
    fence >> (fence.absent? >> pre.line).repeat(1) >> fence
  end

  rule :fence do
    (str('`').repeat(3) | str('~').repeat(3)) >> pre.eol
  end

  def pre
    @@pre ||= CommonMark::Parser::Preliminaries.new
  end
end
