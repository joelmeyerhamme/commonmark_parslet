class CommonMark::Parser::LeafBlock::HtmlBlock < Parslet::Parser
  TAGS = ['article', 'header', 'aside', 'hgroup', 'blockquote', 'hr',
    'iframe', 'body', 'li', 'map', 'button', 'object', 'canvas', 'ol',
    'caption', 'output', 'col', 'p', 'colgroup', 'pre', 'dd', 'progress',
    'div', 'section', 'dl', 'table', 'td', 'dt', 'tbody', 'embed', 'textarea',
    'fieldset', 'tfoot', 'figcaption', 'th', 'figure', 'thead', 'footer',
    'tr', 'form', 'ul', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'video',
    'script', 'style', '?', '!']

  root :html_block

  rule :html_block do
    pre.space_character.repeat(0, 3) >> tag >> ((pre.eol >> pre.blank_line).absent? >> any).repeat
  end

  rule :tag do
    str('<') >> tags >> str('>').maybe
  end

  def tags
    @tags ||= TAGS.map { |t| str(t) }.reduce(:|)
  end

  def pre
    @pre ||= CommonMark::Parser::Preliminaries.new
  end
end
