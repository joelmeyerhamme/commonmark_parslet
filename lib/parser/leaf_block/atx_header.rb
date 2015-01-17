class CommonMark::Parser::LeafBlock::AtxHeader < Parslet::Parser
  root(:atx_header)

  def atx_header_def
    pre.space_character.repeat(0,3) >> str("#").repeat(1,6) >> pre.whitespace_character.repeat(1,3) >> pre.character.repeat(1) >>
      (pre.whitespace.repeat(1) >> str('#').repeat(1)).maybe >> pre.eol >> pre.blank_line
  end
  rule(:atx_header) { atx_header_def }

  def pre
    @@pre ||= CommonMark::Parser::Preliminaries.new
  end
end
