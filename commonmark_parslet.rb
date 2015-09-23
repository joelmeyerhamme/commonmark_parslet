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
      space.repeat(0, 3) >> (
        hrule.as(:hrule) |
        atx_header.as(:atx_header)
        )
    end

    rule :atx_header do
      str('#').repeat(1, 6).as(:grade) >> space.repeat(1) >> inline.as(:inline)
    end

    rule :inline do
      (newline.absent? >> any).repeat
    end

    rule :newline do
      str('\n')
    end

    rule :space do
      str(' ')
    end

    rule :hrule do
      (str('-') >> space.repeat(0)).repeat(3) |
      (str('*') >> space.repeat(0)).repeat(3) |
      (str('_') >> space.repeat(0)).repeat(3)
    end
  end
end
