require './spec/spec_helper.rb'

describe UnicodeData::CharClass do
  subject (:unicode_class) { described_class }

  it "should return the characters of the given class" do
    # line separator
    expect(unicode_class["Zl"]).to eq(["2028"])
    # eq("\u2028".each_codepoint.map(&:to_s[16]))
  end
end
