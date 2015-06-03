class CommonMark::Parser::LeafBlock::LinkReferenceDefinition < Parslet::Parser
  root :link_reference_definition

  rule :link_reference_definition do
    upto_3_spaces >> label >> colon >> upto_1_newline >> opt_white_space >>
      url >> upto_1_newline >> opt_white_space >>
      quoted(pre.character | pre.whitespace) >> upto_1_newline
  end

  rule :url do
    (match['"\''].absent? >> any).repeat(1)
  end

  rule :label do
    left_bracket >>
      ((right_bracket.absent?) >> pre.character | pre.whitespace).repeat(1) >>
      right_bracket
  end

  rule :upto_3_spaces do
    pre.space_character.repeat(0,3)
  end

  rule :upto_1_newline do
    pre.whitespace.maybe >> pre.eol.maybe
  end

  rule :opt_white_space do
    pre.whitespace.maybe
  end

  rule :left_bracket do
    no_escape >> str('[')
  end

  rule :right_bracket do
    no_escape >> str(']')
  end

  rule :colon do
    no_escape >> str(':')
  end

  rule :no_escape do
    str('\\').absent?
  end

  def quoted(content)
    match['"\''].capture(:quote) >>
      dynamic do |s,c|
        quote = str(c.captures[:quote])
        (quote.absent? >> content).repeat(1) >> quote
      end
  end

  def pre
    @pre ||= CommonMark::Parser::Preliminaries.new
  end
end
