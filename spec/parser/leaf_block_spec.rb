require './spec/spec_helper'

describe CommonMark::Parser::LeafBlock do
  it "should parse hrules" do
    expect(subject.parse("***"))
  end
end
