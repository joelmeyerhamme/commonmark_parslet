class CommonMark::Parser::LeafBlock::IndentedBlock < Parslet::Parser
  root :indented_block

  rule :indented_block do
    line >> (line | internal_blank_line).repeat
  end

  rule :line do
    pre.tab >> pre.line
  end

  rule :internal_blank_line do
    pre.blank_line.repeat(1) >> pre.tab.present? 
  end

  def pre
    @@pre ||= CommonMark::Parser::Preliminaries.new
  end
end
