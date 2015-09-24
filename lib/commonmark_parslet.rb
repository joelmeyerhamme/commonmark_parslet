module CommonMark
  class Parser < Parslet::Parser
    root :document

    def rule(name, opts={}, &definition)
      @rules ||= {}     # <name, rule> memoization
        return @rules[name] if @rules.has_key?(name)
        definition_closure = proc { self.instance_eval(&definition) }
        @rules[name] = Atoms::Entity.new(name, &definition_closure)
      end

    def document
      rule :document do
        (line >> newline).repeat
      end
    end

    def line
      rule :line do
        fenced_code_block | hrule | atx_header | quote | list |
        indented_code | link_ref_def | inline | blank
      end
    end

    def blank
      rule :blank do
        (space.repeat(1) >> str("\n").absent?).as(:blank)
      end
    end

    def quote
      rule :quote do
        (opt_indent >> str('>') >> space.maybe >> line).as(:quote)
      end
    end

    def list
      rule :list do
        ordered_list | unordered_list
      end
    end

    def ordered_list
      rule :ordered_list do
        (opt_indent >> match['\d+'] >> match['\.\)'] >> space >> line).as(:ordered_list)
      end
    end

    def unordered_list
      rule :unordered_list do
        (opt_indent >> match['-+*'] >> space >> line).as(:unordered_list)
      end
    end

    def atx_header
      rule :atx_header do
        opt_indent >> (str('#').repeat(1, 6).as(:grade) >> space.repeat(1) >> inline).as(:atx_header)
      end
    end

    def indented_code
      rule :indented_code do
        space.repeat(4) >> text.as(:indented_code)
      end
    end

    def fenced_code_block
      rule :fenced_code_block do
        opt_indent >> fence.capture(:fence) >> str("\n") >>
          dynamic do |s,c|
            (str(c.captures[:fence]).absent? >> text >> newline).repeat(1) >> str(c.captures[:fence])
          end
        end.as(:fenced_code_block)
    end

    def link_ref_def
      rule :link_ref_def do
        opt_indent >> (str('[') >> (str(']').absent? >> any).repeat.as(:ref) >> str(']:') >> space >>
          (space.absent? >> any).repeat.as(:destination) >> space >> match['\'"'].capture(:quote) >> dynamic do |s,c|
            (str(c.captures[:quote]).absent? >> any).repeat(1).as(:title) >> str(c.captures[:quote])
          end).as(:ref_def)
      end
    end

    def opt_indent
      rule :opt_indent do
        space.repeat(0, 3)
      end
    end

    def fence
      rule :fence do
        str('`').repeat(3) | str('~').repeat(3)
      end
    end

    def inline
      rule :inline do
        (escaped | entity | code_span | delimiter | link | image | autolink | text).repeat(1).as(:inline)
      end
    end

    def autolink
      rule :autolink do
        (str('<') >> (str('>').absent? >> any).repeat(1).as(:destination) >> str('>')).as(:link)
      end
    end

    def image
      rule :image do
        (str('![') >> (str(']').absent? >> any).repeat.as(:description) >> str('](') >>
        (space.absent? >> any).repeat.as(:source) >> (space >> match['\'"'].capture(:quote) >> dynamic do |s,c|
            (str(c.captures[:quote]).absent? >> any).repeat(1).as(:title) >> str(c.captures[:quote])
          end).maybe >> str(')')).as(:image)
      end
    end

    def link
      rule :link do
        (str('[') >> (str(']').absent? >> any).repeat.as(:text) >> str('](') >>
        (space.absent? >> any).repeat.as(:destination) >> (space >> match['\'"'].capture(:quote) >> dynamic do |s,c|
            (str(c.captures[:quote]).absent? >> any).repeat(1).as(:title) >> str(c.captures[:quote])
          end).maybe >> str(')')).as(:link)
      end
    end

    def delimiter
      rule :delimiter do
        left_delimiter | right_delimiter
      end
    end

    def left_delimiter
      rule :left_delimiter do
        (delimiter_ >> flank).as(:left_delimiter)
      end
    end

    def right_delimiter
      rule :right_delimiter do
        (flank >> delimiter_).as(:right_delimiter)
      end
    end

    def delimiter_
      rule :delimiter_ do
        str('*').repeat(1,3) | str('_').repeat(1,3)
      end
    end

    def flank
      rule :flank do
        (any.present? >> str(' ').absent?)
      end
    end

    def entity
      rule :entity do
        (html_entity | decimal_entity | hex_entity).as(:entity)
      end
    end

    def html_entity
      rule :html_entity do
        str('&') >> (str(';').absent? >> match['a-zA-Z'].repeat(1)) >> str(';')
      end
    end

    def decimal_entity
      rule :decimal_entity do
        str('&#') >> (str(';').absent? >> match['0-9'].repeat(1, 8)) >> str(';')
      end
    end

    def hex_entity
      rule :hex_entity do
        str('&#') >> match['xX'] >> (str(';').absent? >> match['0-9'].repeat(1, 8)) >> str(';')
      end
    end

    def code_span
      rule :code_span do
        str('`').repeat(1).capture(:backtick_string) >>
        dynamic do |s,c|
          (str(c.captures[:backtick_string]).absent? >> newline.absent? >> any).repeat(1).as(:code_span) >> str(c.captures[:backtick_string])
        end
      end
    end

    def escaped
      rule :escaped do
        str('\\') >> any.as(:escaped) # actually only punctuation
      end
    end

    def text
      rule :text do
        space.absent? >> (newline.absent? >> delimiter.absent? >> any).repeat(1).as(:text)
      end
    end

    def newline
      rule :newline do
        str('  ').as(:hard_break).maybe >> (str("\n") | any.absent?)
      end
    end

    def space
      rule :space do
        str(' ')
      end
    end

    def hrule
      rule :hrule do
        opt_indent >> (hrule_('*') | (hrule_('-') | str('=').repeat(1)) | hrule_('_')).as(:hrule)
      end
    end

    def hrule_(char)
      (str(char) >> space.repeat(0)).repeat(3)
    end
  end
end
