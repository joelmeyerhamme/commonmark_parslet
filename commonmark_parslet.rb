require 'rubygems'
require 'bundler'
Bundler.require(:default, :develop)

module CommonMark
  class Parser < Parslet::Parser
    root :document

    rule :document do
      (line >> newline).repeat
    end

    rule :line do
      hrule | atx_header | quote | list | indented_code | link_ref_def | inline | blank
    end

    rule :blank do
      (newline.absent? >> space.repeat(1)).as(:blank)
    end

    rule :quote do
      (opt_indent >> str('>') >> space.maybe >> line).as(:quote)
    end

    rule :list do
      ordered_list | unordered_list
    end

    rule :ordered_list do
      (opt_indent >> match['\d+'] >> match['\.\)'] >> space.maybe >> line).as(:ordered_list)
    end

    rule :unordered_list do
      (opt_indent >> match['-+*'] >> space.maybe >> line).as(:unordered_list)
    end

    rule :atx_header do
      opt_indent >> (str('#').repeat(1, 6).as(:grade) >> space.repeat(1) >> inline).as(:atx_header)
    end

    rule :indented_code do
      space.repeat(4) >> text.as(:indented_code)
    end

    rule :fenced_code_block do
      opt_indent >> fence.capture(:fence) >> str("\n") >>
        dynamic do |s,c|
          (str(c.captures[:fence]).absent? >> text >> newline).repeat(1) >> str(c.captures[:fence])
        end
    end

    rule :link_ref_def do
      opt_indent >> (str('[') >> (str(']').absent? >> any).repeat.as(:ref) >> str(']:') >> space >>
        (space.absent? >> any).repeat.as(:link) >> space >> match['\'"'].capture(:quote) >> dynamic do |s,c|
          (str(c.captures[:quote]).absent? >> any).repeat(1).as(:title) >> str(c.captures[:quote])
        end).as(:ref_def)
    end

    rule :opt_indent do
      space.repeat(0, 3)
    end

    rule :fence do
      str('`').repeat(3) | str('~').repeat(3)
    end

    rule :inline do
      (escaped | entity | code_span | text).as(:inline)
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

    # def entity_(m)
    # end

    rule :code_span do
      str('`') >> (str('`').absent? >> newline.absent? >> any).repeat(1).as(:code_span) >> str('`')
    end

    rule :escaped do
      str('\\') >> any.as(:escaped) # actually only punctuation
    end

    rule :text do
      space.absent? >> (newline.absent? >> any).repeat(1)
    end

    rule :newline do
      str("\n") | any.absent?
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
end
