require './spec/spec_helper.rb'

describe UnicodeData::CharClass do
  subject { described_class }

  it 'should return the characters of the given class' do
    # line separator
    expect(subject['Zl']).to eq(['2028'])
  end
end
