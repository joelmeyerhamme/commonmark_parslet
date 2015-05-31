require './spec/spec_helper'

describe CommonMark::Parser::LeafBlock::AtxHeader do
  it 'should parse h1' do
    is_expected.to parse('# header')
  end

  it 'should parse h2' do
    is_expected.to parse('## header')
  end

  it 'should parse h3' do
    is_expected.to parse('### header')
  end

  it 'should parse h4' do
    is_expected.to parse('#### header')
  end

  it 'should parse h5' do
    is_expected.to parse('##### header')
  end

  it 'should parse h6' do
    is_expected.to parse('###### header')
  end

  it 'should not parse parse h7' do
    is_expected.not_to parse('####### header')
  end

  it 'should not parse missing space' do
    is_expected.not_to parse('#5 bolt')
  end

  it 'should not parse escaped octothorpe' do
    is_expected.not_to parse('\\## foo')
  end

  it 'should parse inlines' do
    pending 'inlines not yet implemented'
    CommonMark::Parser::Inline
    is_expected.to parse('# foo *bar* \*baz\*')
  end

  it 'should ignore whitespace' do
    is_expected.to parse("##{' ' * 18}foo#{' ' * 21}")
  end

  it 'should parse leading spaces' do
    is_expected.to parse('### foo')
    is_expected.to parse(' ## foo')
    is_expected.to parse('  # foo')
  end

  it 'should not parse indented headers' do
    is_expected.not_to parse('    # foo')
    is_expected.not_to parse("foo\n    # bar")
  end

  it 'should parse closing octothorpes' do
    is_expected.to parse('## foo ##')
    is_expected.to parse('  ###   bar    ###')
  end

  it 'should parse closing sequence of different length' do
    is_expected.to parse('# foo ##################################')
    is_expected.to parse('##### foo ##')
  end

  it 'should parse spaces after closing sequence' do
    is_expected.to parse('### foo ###     ')
  end

  it 'should parse closing # with trailing non-space chars as content' do
    is_expected.to parse('### foo ### b')
  end

  it 'should require a space before the closing sequence' do
    is_expected.to parse('# foo#')
  end

  it 'should not parse escaped # as closing sequence' do
    is_expected.to parse('### foo \\###')
    is_expected.to parse('## foo #\\##')
    is_expected.to parse('# foo \\#')
  end
end

# Contents are parsed as inlines:

# Example 27  (interact)
# # foo *bar* \*baz\*
# <h1>foo <em>bar</em> *baz*</h1>
# Leading and trailing blanks are ignored in parsing inline content:

# Example 28  (interact)
# #                  foo
# <h1>foo</h1>
# One to three spaces indentation are allowed:

# Example 29  (interact)
#  ### foo
#   ## foo
#    # foo
# <h3>foo</h3>
# <h2>foo</h2>
# <h1>foo</h1>
# Four spaces are too much:

# Example 30  (interact)
#     # foo
# <pre><code># foo
# </code></pre>
# Example 31  (interact)
# foo
#     # bar
# <p>foo
# # bar</p>
# A closing sequence of # characters is optional:

# Example 32  (interact)
# ## foo ##
#   ###   bar    ###
# <h2>foo</h2>
# <h3>bar</h3>
# It need not be the same length as the opening sequence:

# Example 33  (interact)
# # foo ##################################
# ##### foo ##
# <h1>foo</h1>
# <h5>foo</h5>
# Spaces are allowed after the closing sequence:

# Example 34  (interact)
# ### foo ###
# <h3>foo</h3>
# A sequence of # characters with a non-space character following it is not a closing sequence, but counts as part of the contents of the header:

# Example 35  (interact)
# ### foo ### b
# <h3>foo ### b</h3>
# The closing sequence must be preceded by a space:

# Example 36  (interact)
# # foo#
# <h1>foo#</h1>
# Backslash-escaped # characters do not count as part of the closing sequence:

# Example 37  (interact)
# ### foo \###
# ## foo #\##
# # foo \#
# <h3>foo ###</h3>
# <h2>foo ###</h2>
# <h1>foo #</h1>
# ATX headers need not be separated from surrounding content by blank lines, and they can interrupt paragraphs:

# Example 38  (interact)
# ****
# ## foo
# ****
# <hr />
# <h2>foo</h2>
# <hr />
# Example 39  (interact)
# Foo bar
# # baz
# Bar foo
# <p>Foo bar</p>
# <h1>baz</h1>
# <p>Bar foo</p>
# ATX headers can be empty:

# Example 40  (interact)
# ##
# #
# ### ###
# <h2></h2>
# <h1></h1>
# <h3></h3>
