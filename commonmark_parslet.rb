require 'rubygems'
require 'bundler'
Bundler.require(:default, :develop)

module CommonMark
  class Parser < Parslet::Parser
    root :document

    rule :document do
      line.repeat
    end

    rule :line do
      (hrule | atx_header | quote | indented_code | link_ref_def | inline.as(:inline)) >> newline | (newline.absent? >> space.repeat(1) >> newline).as(:blank)
    end

    rule :quote do
      (opt_indent >> str('>') >> space >> line).as(:quote)
    end

    rule :atx_header do
      opt_indent >> (str('#').repeat(1, 6).as(:grade) >> space.repeat(1) >> inline.as(:inline)).as(:atx_header)
    end

    rule :indented_code do
      space.repeat(4) >> inline.as(:indented_code)
    end

    rule :fenced_code_block do
      opt_indent >> fence.capture(:fence) >> str("\n") >>
        dynamic do |s,c|
          (str(c.captures[:fence]).absent? >> inline >> newline).repeat(1) >> str(c.captures[:fence])
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
      (newline.absent? >> space.absent? >> any) >>
      (newline.absent? >> any).repeat(1)
    end

    rule :newline do
      str('\n') | any.absent?
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
