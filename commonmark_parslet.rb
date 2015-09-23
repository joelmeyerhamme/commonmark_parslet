require 'rubygems'
require 'bundler'
Bundler.require(:default)

module CommonMark
  class Parser < Parslet::Parser
    root :document

    rule :document do
      line.repeat
    end

    rule :line do
        (hrule | atx_header | indented_code | fenced_code_block) >> newline
    end

    rule :atx_header do
      space.repeat(0, 3) >> (str('#').repeat(1, 6).as(:grade) >> space.repeat(1) >> inline.as(:inline)).as(:atx_header)
    end

    rule :indented_code do
      space.repeat(4) >> inline.as(:indented_code)
    end

    rule :fenced_code_block do
      space.repeat(0, 3) >> fence.capture(:fence) >> str("\n") >>
        dynamic do |s,c|
          (str(c.captures[:fence]).absent? >> inline >> newline).repeat(1) >> str(c.captures[:fence])
        end
    end

    rule :fence do
      str('`').repeat(3) | str('~').repeat(3)
    end

    rule :inline do
      (newline.absent? >> any).repeat
    end

    rule :newline do
      str('\n') | any.absent?
    end

    rule :space do
      str(' ')
    end

    rule :hrule do
      space.repeat(0, 3) >>
      ((str('-') >> space.repeat(0)).repeat(3) |
        (str('*') >> space.repeat(0)).repeat(3) |
        (str('_') >> space.repeat(0)).repeat(3)).as(:hrule)
    end
  end
end
