require './spec/spec_helper'

describe CommonMark::Parser::LeafBlock::HtmlBlock do
  it 'should consume html tags' do
    is_expected.to parse("<table>\n  <tr>\n    <td>\n           hi\n    </td>\n  </tr>\n</table>")
  end

  it 'should consume indentation' do
    is_expected.to parse(" <div>\n  *hello*\n         <foo><a>")
  end

  it 'should note parse markdown in between html blocks' do
    is_expected.not_to parse("<DIV CLASS=\"foo\">\n\n*Markdown*\n\n</DIV>")
  end

  it 'should parse any block starting with an html tag' do
    is_expected.to parse("<div></div>\n``` c\nint x = 33;\n```")
  end

  it 'should parse html comments' do
    is_expected.to parse("<!-- Foo\nbar\n   baz -->")
  end

  it 'should parse processing instructions' do
    is_expected.to parse("<?php\n  echo '>';\n?>")
  end

  it 'should parse CDATA blocks' do
    is_expected.to parse("<![CDATA[\nfunction matchwo(a,b)\n{\nif (a < b &&\
      a < 0) then\n  {\n  return 1;\n  }\nelse\n  {\n  return 0;\n  }\n}\n]]>")
  end

  it 'should allow 1-3 spaces indentation' do
    is_expected.to parse("  <!-- foo -->")
    is_expected.not_to parse("    <!-- foo -->")
  end

  it 'should interrupt a paragraph' do
    pending 'paragraph and precedences not yet implemented'
    is_expected.to parse("Foo\n<div>\nbar\n</div>")
  end

  it 'should not be interrupted' do
    # pending 'precendeces not yet implemented'
    is_expected.to parse("<div>\nbar\n</div>\n*foo*")
  end

  it 'should parse incomplete html tags' do
    is_expected.to parse("<div class\nfoo")
  end
end
