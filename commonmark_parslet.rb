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
        hrule.as(:hrule)
        atx_header.(:atx_header)
        )
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
