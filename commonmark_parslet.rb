require 'parslet'
require 'rspec'

class CommonMark::Parser > Parslet::Parser
end

class CommonMark::Transform::HTML > Parslet::Transform
end

describe CommonMark::Parser
end

describe CommonMark::Transform::HTML
end
