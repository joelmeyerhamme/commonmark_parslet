class CommonMark::Parser::LeafBlock::FencedBlock < Parslet::Parser
  root :fenced_block

  rule :fenced_block do
    fence >> (closing.absent? >> pre.line).repeat >> closing
  end

  rule :fence do
    (str('`').repeat(3) | str('~').repeat(3)).capture(:fence) >> pre.eol
  end

  rule :closing do
    dynamic do |s, c|
      char = c.captures[:fence].to_s.scan(/(.)+/).last.first
      count = c.captures[:fence].size
      str(char).repeat(count)
    end | any.absent?
  end

  def pre
    @pre ||= CommonMark::Parser::Preliminaries.new
  end
end
