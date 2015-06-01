class CommonMark::Parser::LeafBlock::LinkReferenceDefinition < Parslet::Parser
  root :link_reference_definition

  rule :link_reference_definition do
    pre.space_character.repeat(0,3) >>
      str('[') >>
      (str(']').absent? >> pre.character | pre.whitespace).repeat(1) >>
      str(']:') >>
      pre.whitespace.maybe >> pre.eol.maybe >> pre.whitespace.maybe >>
      (match['"\''].absent? >> any).repeat(1) >>
      pre.whitespace.maybe >> pre.eol.maybe >> pre.whitespace.maybe >>
      (match['"\''].capture(:quote) >>
      dynamic do |s,c|
        quote = str(c.captures[:quote])
        (quote.absent? >> pre.character | pre.whitespace).repeat(1) >> quote
      end ) >> pre.whitespace.maybe >> pre.eol
  end

  def pre
    @pre ||= CommonMark::Parser::Preliminaries.new
  end
end
