class CommonMark::Parser::ContainerBlock::BlockQuote < Parslet::Parser
  root :block_quote

  rule :block_quote do
    (pre.eol.absent? >> (mark >> line >> pre.eol)).repeat(1)
  end

  rule :line do
   (pre.eol.absent? >> content).repeat(0)
  end

  rule :mark do
    pre.whitespace_character.repeat(0, 3) >> str('>') >> pre.whitespace_character.maybe
  end

  rule :content do
    any
  end

  def pre
    @pre ||= CommonMark::Parser::Preliminaries.new
  end
end
