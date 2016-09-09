module CommonMark
  class Parser < Parslet::Parser
    root :document

    rule :document do
      any.absent?.as(:blank) | (block | blank).repeat.as(:document)
    end

    rule :block do
      fenced_code_block |
      hrule |
      atx_header |
      quote |
      list |
      indented_code |
      link_ref_def |
      setext_header |
      paragraph >>
      newline
    end

    def block_repeat(body, delimiter, secondary=body)
      (body.repeat(1,1) >> (delimiter >> secondary).repeat)
    end

    rule :paragraph do
      block_repeat(inline, newline, line).as(:paragraph)
    end

    rule :line do
      dynamic do |s, c|
        begin
          str(c.captures[:marker]) >> scope { inline } # TODO: should be line, recursing quote levels
        rescue Parslet::Scope::NotFound => e
          any.present? >> inline
        end
      end
    end

    rule :setext_header do
      (opt_indent >> inline >> newline >>
        opt_indent >> setext_grade).as(:setext_header)
    end

    rule :setext_grade do
      str('=').repeat(1).as(:grade_1) | str('-').repeat(1).as(:grade_2)
    end

    rule :quote do
      ((marker >> space.maybe).capture(:marker) >> block.repeat(1)).as(:quote)
    end

    rule :marker do
      (opt_indent >> str('>'))
    end

    rule :blank do
      (space.repeat >> line_feed.repeat(1) | space.repeat(1) >> line_feed.repeat(0)).as(:blank)
    end

    rule :list do
      ordered_list | unordered_list
    end

    rule :ordered_list do
      ((opt_indent >> match['\d+'] >> match['\.\)'] >> space) >> inline >> newline).repeat(1).as(:ordered_list)
    end

    rule :unordered_list do
      (opt_indent >> match['-+*'] >> space >> inline).as(:unordered_list) # >>
    end

    # rule :unordered_list_marker do
    #   (opt_indent >> match['-+*'] >> space.repeat(1)).capture(:unordered_list_marker)
    # end

    rule :atx_header do
      opt_indent >>
        (str('#').repeat(1, 6).as(:grade) >>
          space.repeat(1) >> inline).as(:atx_header)
    end

    rule :indented_code do
      (tab >> text >> newline).repeat(1).as(:indented_code)
    end

    rule :tab do
      str("\t") | space.repeat(4, 4)
    end

    rule :fenced_code_block do
      opt_indent >> fence.capture(:fence) >> str("\n") >>
        dynamic do |s, c|
          (str(c.captures[:fence]).absent? >> text >> newline).repeat(1) >>
            str(c.captures[:fence])
        end.as(:fenced_code_block)
    end

    rule :link_ref_def do
      opt_indent >> (str('[') >> (str(']').absent? >> any).repeat.as(:ref) >> str(']:') >>
        space >> (space.absent? >> any).repeat.as(:destination) >>
          space >> match['\'"'].capture(:quote) >>
            dynamic do |s, c|
              (str(c.captures[:quote]).absent? >> any).repeat(1).as(:title) >>
                str(c.captures[:quote])
            end).as(:ref_def)
    end

    rule :opt_indent do
      space.repeat(0, 3)
    end

    rule :fence do
      str('`').repeat(3) | str('~').repeat(3)
    end

    rule :inline do
      (escaped | entity | code_span | delimiter |
        link | image | autolink | text).repeat(1).as(:inline)
    end

    rule :autolink do
      (str('<') >> (str('>').absent? >> any).repeat(1).as(:destination) >>
        str('>')).as(:link)
    end

    rule :image do
      (str('![') >> (str(']').absent? >> any).repeat.as(:description) >> str('](') >>
        (space.absent? >> any).repeat.as(:source) >>
          (space >> match['\'"'].capture(:quote) >>
            dynamic do |s, c|
              (str(c.captures[:quote]).absent? >> any).repeat(1).as(:title) >>
                str(c.captures[:quote])
              end).maybe >> str(')')).as(:image)
    end

    rule :link do
      (str('[') >> (str(']').absent? >> any).repeat.as(:text) >> str('](') >>
        (space.absent? >> any).repeat.as(:destination) >>
          (space >> match['\'"'].capture(:quote) >>
            dynamic do |s, c|
              (str(c.captures[:quote]).absent? >> any).repeat(1).as(:title) >>
                str(c.captures[:quote])
            end).maybe >> str(')')).as(:link)
    end

    rule :delimiter do
      left_delimiter | right_delimiter
    end

    rule :left_delimiter do
      (delimiter_ >> flank).as(:left_delimiter)
    end

    rule :right_delimiter do
      (flank >> delimiter_).as(:right_delimiter)
    end

    rule :delimiter_ do
      str('*').repeat(1, 3) | str('_').repeat(1, 3)
    end

    rule :flank do
      (any.present? >> str(' ').absent?)
    end

    rule :entity do
      (html_entity | decimal_entity | hex_entity).as(:entity)
    end

    rule :html_entity do
      str('&') >> (str(';').absent? >> match['a-zA-Z'].repeat(1)) >> str(';')
    end

    rule :decimal_entity do
      str('&#') >> (str(';').absent? >> match['0-9'].repeat(1, 8)) >> str(';')
    end

    rule :hex_entity do
      str('&#') >> match['xX'] >> (str(';').absent? >> match['0-9'].repeat(1, 8)) >> str(';')
    end

    rule :code_span do
      str('`').repeat(1).capture(:backtick_string) >>
        dynamic do |s, c|
          (str(c.captures[:backtick_string]).absent? >> newline.absent? >>
            any).repeat(1).as(:code_span) >> str(c.captures[:backtick_string])
        end
    end

    rule :escaped do
      str('\\') >> any.as(:escaped) # actually only punctuation
    end

    rule :text do
      space.absent? >> (newline.absent? >> delimiter.absent? >> any).repeat(1).as(:text)
    end

    rule :newline do
      any.absent? | line_feed
    end

    rule :line_feed do
      hard_break.maybe >> str("\n")
    end

    rule :hard_break do
      space.repeat(2, 2).as(:hard_break)
    end

    rule :space do
      str(' ')
    end

    rule :hrule do
      opt_indent >> (hrule_('*') | hrule_('-') | hrule_('_')).as(:hrule)
    end

    def hrule_(char)
      (str(char) >> space.repeat(0)).repeat(3)
    end
  end

  class HtmlTransform < Parslet::Transform
    rule("\u0000") { "\ufffd" }

    rule(inline: sequence(:block)) { block.join }

    rule(setext_header: {inline: sequence(:content), grade_1: simple(:grade_1)}) do
      "<h1>#{content.join}</h1>"
    end

    rule(setext_header: {inline: sequence(:content), grade_2: simple(:grade_2)}) do
      "<h2>#{content.join}</h2>"
    end

    rule(hrule: simple(:x)) { '<hr />' }

    rule(text: simple(:text)) { "#{text}" }

    rule(paragraph: sequence(:lines)) { "<p>#{lines.join("\n")}</p>"}

    rule(atx_header: {grade: simple(:grade), inline: sequence(:content)}) do
      "<h#{grade.size}>#{content.join}</h#{grade.size}>"
    end

    rule(indented_code: sequence(:code)) { "<pre><code>#{code.join("\n")}\n</code></pre>" }

    rule(document: sequence(:x)) { x.join("\n") }
  end
end
