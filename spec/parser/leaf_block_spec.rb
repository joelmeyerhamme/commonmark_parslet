require './spec/spec_helper'

describe CommonMark::Parser::LeafBlock do
  it 'should parse hrules' do
    expect(subject.parse('***'))
  end
end

# ATX headers need not be separated from surrounding content by blank lines, and they can interrupt paragraphs:

# Example 38
# ****
# ## foo
# ****
# <hr />
# <h2>foo</h2>
# <hr />
# Example 39
# Foo bar
# # baz
# Bar foo
# <p>Foo bar</p>
# <h1>baz</h1>
# <p>Bar foo</p>
# ATX headers can be empty:

# Example 40
# ##
# #
# ### ###
