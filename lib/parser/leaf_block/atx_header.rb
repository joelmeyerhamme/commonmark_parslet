class CommonMark::Parser::LeafBlock::AtxHeader < Parslet::Parser
  root :atx_header

  rule :atx_header do
    pre.space_character.repeat(0,3) >> str("#").repeat(1,6) >> pre.whitespace_character.repeat(1,3) >> pre.character.repeat(1) >>
      (pre.whitespace.repeat(1) >> str('#').repeat(1)).maybe >> pre.eol >> pre.blank_line
  end

  def pre
    @@pre ||= CommonMark::Parser::Preliminaries.new
  end
end
