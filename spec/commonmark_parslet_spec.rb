require './spec/spec_helper'

describe CommonMark::Parser do
  describe 'hrule' do
    it 'should parse hline with *' do
      expect(subject.parse_with_debug('***')).to eq({document: [{hrule: '***'}]})
    end

    it 'should parse hline with *' do
      expect(subject.parse_with_debug('---')).to eq({document: [{hrule: '---'}]})
    end

    it 'should parse hline with *' do
      expect(subject.parse_with_debug('___')).to eq({document: [{hrule: '___'}]})
    end

    it 'should parse upto three whitespaces' do
      expect(subject.parse_with_debug(' ***')).to eq({document: [{hrule: '***'}]})
      expect(subject.parse_with_debug('  ***')).to eq({document: [{hrule: '***'}]})
      expect(subject.parse_with_debug('   ***')).to eq({document: [{hrule: '***'}]})
    end

    it 'should parse spaces' do
      expect(subject.parse_with_debug(' - - -')).to eq(
        {document: [{hrule: '- - -'}]})
      expect(subject.parse_with_debug(' **  * ** * ** * **')).to eq(
        {document: [{hrule: '**  * ** * ** * **'}]})
      expect(subject.parse_with_debug('-     -      -      -')).to eq(
        {document: [{hrule: '-     -      -      -'}]})
      expect(subject.parse_with_debug('- - - -    ')).to eq(
        {document: [{hrule: '- - - -    '}]})
    end
  end

  describe 'header' do
    it 'should parse atx headers' do
      expect(subject.parse_with_debug('# foo')).to eq(
        {document: [{atx_header: {grade: '#', inline: [{text: 'foo'}]}}]})
      expect(subject.parse_with_debug('## foo')).to eq(
        {document: [{atx_header: {grade: '##', inline: [{text: 'foo'}]}}]})
      expect(subject.parse_with_debug('### foo')).to eq(
        {document: [{atx_header: {grade: '###', inline: [{text: 'foo'}]}}]})
      expect(subject.parse_with_debug('#### foo')).to eq(
        {document: [{atx_header: {grade: '####', inline: [{text: 'foo'}]}}]})
      expect(subject.parse_with_debug('##### foo')).to eq(
        {document: [{atx_header: {grade: '#####', inline: [{text: 'foo'}]}}]})
      expect(subject.parse_with_debug('###### foo')).to eq(
        {document: [{atx_header: {grade: '######', inline: [{text: 'foo'}]}}]})
      expect(subject.parse_with_debug('#    foo')).to eq(
        {document: [{atx_header: {grade: '#', inline: [{text: 'foo'}]}}]})
    end

    it 'should parse setext headers' do
      expect(subject.parse_with_debug("Foo bar\n=========")).to eq(
        {document: [{setext_header:
          {inline: [{text: 'Foo bar'}], grade_1: '========='}}]})
      expect(subject.parse_with_debug("Foo bar\n---------")).to eq(
        {document: [{setext_header:
          {inline: [{text: 'Foo bar'}], grade_2: '---------'}}]})
    end
  end

  it 'should parse indented code blocks' do
    expect(subject.parse_with_debug("    code block")).to eq(
      {document: [{indented_code: [{text: 'code block'}]}]})
  end

  it 'should parse fenced code blocks' do
    expect(subject.parse_with_debug("```\nhello\nworld\n```")).to eq(
      {document: [{fenced_code_block: [{text: "hello"}, {text: "world"}]}]})
  end

  it 'should parse link refernce defitions' do
    expect(subject.parse_with_debug('[foo]: /url "title"')).to eq(
      {document: [{ref_def: {ref: 'foo', destination: '/url', title: 'title'}}]})
  end

  it 'should parse single line paragraphs' do
    expect(subject.parse_with_debug('hello world')).to eq(
      {document: [{paragraph: [{inline: [{text: 'hello world'}]}]}]})
  end

  it 'should parse multi line paragraphs' do
    expect(subject.parse_with_debug("hello\nworld")).to eq(
      {document: [{paragraph: [{inline: [{text: 'hello'}]}, {inline: [{text: 'world'}]}]}]})
    expect(subject.parse_with_debug("hello \nworld")).to eq(
      {document: [{paragraph: [{inline: [{text: 'hello '}]}, {inline: [{text: 'world'}]}]}]})
  end

  describe 'should parse blank lines' do
    it 'should parse spaces' do
      expect(subject.parse_with_debug(' ')).to    eq({document: [{blank: ' '}]})
      expect(subject.parse_with_debug('   ')).to  eq({document: [{blank: '   '}]})
      expect(subject.parse_with_debug('    ')).to eq({document: [{blank: '    '}]})
    end

    it 'should parse empty lines' do
      expect(subject.parse_with_debug("\n")).to eq({document: [{blank: "\n"}]})
    end

    it 'should parse itermediary empty lines' do
      expect(subject.parse_with_debug("hello\n\nworld")).to eq(
        {document: [
          {paragraph: [{inline:[{text:"hello"}]}]},
          {blank:"\n"},
          {paragraph: [{inline:[{text:"world"}]}]}]})
    end
  end

  it 'should parse single block quotes' do
    expect(subject.parse_with_debug('> hello world')).to eq(
      {document: [{quote: [{paragraph: [{inline: [{text: 'hello world'}]}]}]}]})
  end

  it 'should parse multi block quotes' do
    expect(subject.parse_with_debug("> hello world\n> hello world")).to eq(
      {document: [
        {quote: [{paragraph: [{inline: [{text: 'hello world'}]}, {inline: [{text: 'hello world'}]}]}]}]})
  end

  it 'should parse ordered lists' do
    expect(subject.parse_with_debug("1. hello\n2. world")).to eq(
      {document: [
        {ordered_list: [
          {inline: [{text: 'hello'}]},
          {inline: [{text: 'world'}]}]}]})
  end

  it 'should parse unordered lists' do
    expect(subject.parse_with_debug("- hello\n- world")).to eq(
      {document: [
        {unordered_list:
          {inline: [{text: 'hello'}]}},
        {unordered_list:
          {inline: [{text: 'world'}]}}]})
  end

  it 'should parse backslash escaped characters' do
    expect(subject.parse_with_debug('\!')).to eq({document: [{paragraph: [{inline: [{escaped: '!'}]}]}]})
  end

  it 'should parse html entities' do
    expect(subject.parse_with_debug('&amp;')).to eq(
      {document: [{paragraph: [{inline: [{entity: '&amp;'}]}]}]})
    expect(subject.parse_with_debug('&#123;')).to eq(
      {document: [{paragraph: [{inline: [{entity: '&#123;'}]}]}]})
    expect(subject.parse_with_debug('&#x123;')).to eq(
      {document: [{paragraph: [{inline: [{entity: '&#x123;'}]}]}]})
  end

  it 'should parse code spans' do
    expect(subject.parse_with_debug('`hello world`')).to eq(
      {document: [{paragraph: [{inline: [{code_span: 'hello world'}]}]}]})
  end

  it 'should parse emphasis' do
    expect(subject.parse_with_debug('*hello*')).to eq({document: [{paragraph: [{inline:[
      {:left_delimiter=>"*"}, {text:"hello"}, {:right_delimiter=>"*"}]}]}]})
  end

  it 'should parse strong emphasis' do
    expect(subject.parse_with_debug('**hello**')).to eq({document: [{paragraph: [{inline: [{
      :left_delimiter=>"**"}, {text: 'hello'}, {:right_delimiter=>"**"}]}]}]})
  end

  it 'should parse links' do
    expect(subject.parse_with_debug('[link](/uri "title")')).to eq({document: [{paragraph: [{inline: [{
      link: {text: 'link', destination: '/uri', title: 'title'}}]}]}]})
  end

  it 'should parse links' do
    expect(subject.parse_with_debug('![description](/uri \'title\')')).to eq({document: [{paragraph: [{inline: [{
      image: {description: 'description', source: '/uri', title: 'title'}}]}]}]})
  end

  it 'should parse autolinks' do
    expect(subject.parse_with_debug('<http://foo.bar.baz>')).to eq(
      {document: [{paragraph: [{inline: [{link: {destination: 'http://foo.bar.baz'}}]}]}]})
  end

  it 'should parse hard breaks' do
    expect(subject.parse_with_debug("text  \ntext")).to eq(
      {document: [{paragraph: [{inline: [{text: 'text'}], hard_break: '  '}, {inline: [{text: 'text'}]}]}]})
  end

  it 'should parse plain text' do
    expect(subject.parse_with_debug('hello $.;\'there')).to eq(
      {document: [{paragraph: [{inline: [{text: "hello $.;'there"}]}]}]})
    expect(subject.parse_with_debug('Foo χρῆν')).to eq(
      {document: [{paragraph: [{inline: [{text: "Foo χρῆν"}]}]}]})
    expect(subject.parse_with_debug('Multiple     spaces')).to eq(
      {document: [{paragraph: [{inline: [{text: "Multiple     spaces"}]}]}]})
  end
end

# describe CommonMark::HtmlTransform do

#   let!(:parser) { CommonMark::Parser.new }

#   def process stream
#     subject.apply(parser.parse_with_debug(stream))
#   end

#   describe 'priliminaries' do
#     describe 'tabs' do
#       it 'should be preseved' do
#         expect(process "\tfoo\tbaz\t\tbim").to eq "<pre><code>foo\tbaz\t\tbim\n</code></pre>"
#         expect(process "\tfoo\tbaz\t\tbim").to eq "<pre><code>foo\tbaz\t\tbim\n</code></pre>"
#         expect(process "    a\ta\n    ὐ\ta").to eq "<pre><code>a\ta\nὐ\ta\n</code></pre>"
#       end

#       it 'should be treated as 4 spaces' do
#         pending "blocks"
#         expect(process "  - foo\n\n\tbar").to eq "<ul>\n<li>\n<p>foo</p>\n<p>bar</p>\n</li>\n</ul>"
#         expect(process ">\tfoo\tbar").to eq "<blockquote>\n<p>foo\tbar</p>\n</blockquote>"
#         expect(process "    foo\n\tbar").to eq "<pre><code>foo\nbar\n</code></pre>"
#       end
#     end

#     describe 'null character' do
#       it 'should be replaced' do
#         expect(process "\u0000").to eq "\ufffd"
#       end
#     end
#   end

#   describe 'precedence' do
#     it 'should parse blocks first' do
#       pending "blocks"
#       expect(process "- `one\n- two`").to eq "<ul>\n<li>`one</li>\n<li>two`</li>\n</ul>"
#     end
#   end

#   describe 'leaf blocks' do
#     describe 'hrules' do
#       it 'should parse hrules' do
#         expect(process "***").to eq "<hr />"
#         expect(process "---").to eq "<hr />"
#         expect(process "___").to eq "<hr />"
#       end

#       it 'should not parse wrong chars as hrules' do
#         expect(process "+++").to eq("<p>+++</p>")
#         expect(process "===").to eq("<p>===</p>")
#       end

#       it 'should not parse too few chars as hrules' do
#         expect(process "--\n**\n__").to eq "<p>--\n**\n__</p>"
#       end

#       it 'should parse hrules with preceding spaces' do
#         expect(process " ***\n  ***\n   ***").to eq "<hr />\n<hr />\n<hr />"
#       end

#       it 'should not parse hrules with more than three spaces' do
#         expect(process "    ***").to eq("<pre><code>***\n</code></pre>")
#         expect(process "Foo\n    ***").to eq("<p>Foo\n***</p>")
#       end

#       it 'should parse hrules with more than three chars' do
#         expect(process "_____________________________________").to eq "<hr />"
#       end

#       it 'should parse spaces' do
#         expect(process " - - -").to eq "<hr />"
#         expect(process " **  * ** * ** * **").to eq "<hr />"
#         expect(process "-     -      -      -").to eq "<hr />"
#         expect(process "- - - -    ").to eq "<hr />"
#       end

#       it 'should not parse any other chars' do
#         expect(process "_ _ _ _ a\n\na------\n\n---a---").to eq "<p>_ _ _ _ a</p>\n<p>a------</p>\n<p>---a---</p>"
#       end

#       it 'should only one sort of hrule char' do
#         expect(process " *-*").to eq "<p><em>-</em></p>"
#       end

#       it 'should not require blank lines' do
#         expect(process "- foo\n***\n- bar").to eq("<ul>\n<li>foo</li>\n</ul>\n<hr />\n<ul>\n<li>bar</li>\n</ul>")
#       end

#       it 'should interrupt a paragraph' do
#         expect(process "Foo\n***\nbar").to eq("<p>Foo</p>\n<hr />\n<p>bar</p>")
#       end

#       it 'should take precedence over setext headers' do
#         expect(process "Foo\n---\nbar").to eq "<h2>Foo</h2>\n<p>bar</p>"
#       end

#       it 'should take precedence over lists' do
#         expect(process "* Foo\n* * *\n* Bar").to eq "<ul>\n<li>Foo</li>\n</ul>\n<hr />\n<ul>\n<li>Bar</li>\n</ul>"
#       end

#       it 'should parse hrules inside lists' do
#         expect(process "- Foo\n- * * *").to eq "<ul>\n<li>Foo</li>\n<li>\n<hr />\n</li>\n</ul>"
#       end
#     end

#     describe 'headers' do
#       describe 'atx headers' do
#         it 'should parse atx headers' do
#           expect(process "# foo\n## foo\n### foo\n#### foo\n##### foo\n###### foo").to eq(
#             "<h1>foo</h1>\n<h2>foo</h2>\n<h3>foo</h3>\n<h4>foo</h4>\n<h5>foo</h5>\n<h6>foo</h6>")
#         end

#         it 'should not parse atx headers with more than six pounds' do
#           expect(process '####### foo'.to eq '<p>####### foo</p>')
#         end

#         it 'should require a space' do
#           expect(process '#5 bolt').to eq '<p>#5 bolt</p>'
#           expect(process '#foobar').to eq '<p>#foobar</p>'
#         end

#         it 'should not parse escaped pounds' do
#           expect(process '\## foo').to eq('<p>## foo</p>')
#         end

#         it 'should parse inlines' do
#           expect(process '# foo *bar* \*baz\*').to eq('<h1>foo <em>bar</em> *baz*</h1>')
#         end

#         it 'should ignore spaces' do
#           expect(process '#                  foo                     ').to eq '<h1>foo</h1>'
#           expect(process ' ### foo\n  ## foo\n   # foo').to eq "<h3>foo</h3>\n<h2>foo</h2>\n<h1>foo</h1>"
#         end

#         it 'should not parse four leading spaces' do
#           expect(process '    # foo').to eq "<pre><code># foo\n</code></pre>"
#           expect(process "foo\n    # bar").to eq "<p>foo\n# bar</p>"
#         end

#         it 'should parse optional closing pounds' do
#           expect(process "## foo ##\n  ###   bar    ###").to eq "<h2>foo</h2>\n<h3>bar</h3>"
#           expect(process "# foo ##################################\n##### foo ##").to eq "<h1>foo</h1>\n<h5>foo</h5>"
#           expect(process '### foo ###     ').to eq '<h3>foo</h3>'
#         end

#         it 'should not parse non space chars after the closing sequence' do
#           expect(process '### foo ### b').to eq '<h3>foo ### b</h3>'
#         end

#         it 'should not parse closing pounds without space' do
#           expect(process '# foo#').to eq '<h1>foo#</h1>'
#         end

#         it 'should not parse escaped closing pounds' do
#           expect(process "### foo \###\n## foo #\##\n# foo \#").to eq "<h3>foo ###</h3>\n<h2>foo ###</h2>\n<h1>foo #</h1>"
#         end

#         it 'should interrupt paragraphs' do
#           expect(process "****\n## foo\n****").to eq "<hr />\n<h2>foo</h2>\n<hr />"
#           expect(process "Foo bar\n# baz\nBar foo").to eq "<p>Foo bar</p>\n<h1>baz</h1>\n<p>Bar foo</p>"
#         end

#         it 'should parse empty headers' do
#           expect(process "## \n#\n### ###").to eq "<h2></h2>\n<h1></h1>\n<h3></h3>"
#         end
#       end

#       describe 'setext headers' do
#         it 'should parse setext headers' do
#           expect(process "Foo *bar*\n=========\n\nFoo *bar*\n---------").to eq(
#             "<h1>Foo <em>bar</em></h1>\n<h2>Foo <em>bar</em></h2>")
#         end

#         it 'should parse any length' do
#           expect(process "Foo\n-------------------------\n\nFoo\n=").to eq "<h2>Foo</h2>\n<h1>Foo</h1>"
#         end

#         it 'should parse upto three spaces indentation' do
#           expect(process "   Foo\n---\n\n  Foo\n-----\n\n  Foo\n  ===").to eq "<h2>Foo</h2>\n<h2>Foo</h2>\n<h1>Foo</h1>"
#         end

#         it 'should not parse four spaces of indentation' do
#           expect(process "    Foo\n    ---\n\n    Foo\n---").to eq "<pre><code>Foo\n---\n\nFoo\n</code></pre>\n<hr />"
#         end

#         it 'should parse trailing spaces' do
#           expect(process "Foo\n   ----      ").to eq "<h2>Foo</h2>"
#         end

#         it 'should not parse internal spaces' do
#           expect(process "Foo\n= =\n\nFoo\n--- -").to eq "<p>Foo\n= =</p>\n<p>Foo</p>\n<hr />"
#         end

#         it 'should ignore trailing spaces in the content' do
#           expect("Foo  \n-----").to eq "<h2>Foo</h2>"
#         end

#         it 'should ignore a trailing backslash in the content' do
#           expect("Foo\\\n----").to eq "<h2>Foo\</h2>"
#         end

#         it 'should take precedence over inlines' do
#           expect("`Foo\n----\n`\n\n<a title=\"a lot\n---\nof dashes\"/>").to eq(
#             "<h2>`Foo</h2>\n<p>`</p>\n<h2>&lt;a title=&quot;a lot</h2>\n<p>of dashes&quot;/&gt;</p>")
#         end

#         it 'should not parse lazy continuation' do
#           expect(process "> Foo\n---").to eq "<blockquote>\n<p>Foo</p>\n</blockquote>\n<hr />"
#           expect(process "- Foo\n---").to eq "<ul>\n<li>Foo</li>\n</ul>\n<hr />"
#         end

#         it 'should not interrupt a paragraph' do
#           expect(process "Foo\nBar\n---\n\nFoo\nBar\n===").to eq "<p>Foo\nBar</p>\n<hr />\n<p>Foo\nBar\n===</p>"
#         end

#         it 'should not require blank lines' do
#           expect(process "---\nFoo\n---\nBar\n---\nBaz").to eq "<hr />\n<h2>Foo</h2>\n<h2>Bar</h2>\n<p>Baz</p>"
#         end

#         it 'should not be empty' do
#           expect(process "\n====").to eq "<p>====</p>"
#         end

#         it 'should not be anything except a paragraph' do
#           expect(process "---\n---").to eq "<hr />\n<hr />"
#           expect(process "- foo\n-----").to eq "<ul>\n<li>foo</li>\n</ul>\n<hr />"
#           expect(process "    foo\n---").to eq "<pre><code>foo\n</code></pre>\n<hr />"
#           expect(process "> foo\n-----").to eq "<blockquote>\n<p>foo</p>\n</blockquote>\n<hr />"
#         end

#         it 'should parse escaped chars' do
#           expect(process "\> foo\n------").to eq "\> foo\n------"
#         end
#       end
#     end

#     describe 'indented code blocks' do
#       it 'should parse code blocks' do
#         expect(process "    a simple\n      indented code block").to eq(
#           "<pre><code>a simple\n  indented code block\n</code></pre>")
#       end

#       it 'should not interrupt a list' do
#         expect(process "  - foo\n\n    bar").to eq("<ul>\n<li>\n<p>foo</p>\n<p>bar</p>\n</li>\n</ul>")
#         expect(process "1.  foo\n\n    - bar").to eq("<ol>\n<li>\n<p>foo</p>\n<ul>\n<li>bar</li>\n</ul>\n</li>\n</ol>")
#       end

#       it 'should not parse inlines' do
#         expect(process "    <a/>\n    *hi*\n\n    - one").to eq "<pre><code>&lt;a/&gt;\n*hi*\n\n- one\n</code></pre>"
#       end

#       it 'should parse multiple chunks' do
#         expect(process "    chunk1\n\n    chunk2\n  \n \n \n    chunk3").to eq "    chunk1\n\n    chunk2\n  \n \n \n    chunk3"
#       end

#       it 'should include internal, preceding and trailing spaces' do
#         expect(process "    chunk1\n      \n      chunk2").to eq "<pre><code>chunk1\n  \n  chunk2\n</code></pre>"
#         expect(process "        foo\n    bar").to eq("<pre><code>    foo\nbar\n</code></pre>")
#         expect(process "    foo  ").to eq("<pre><code>foo  \n</code></pre>")
#       end

#       it 'should not interrupt a paragraph' do
#         expect(process "Foo\n    bar").to eq "<p>Foo\nbar</p>"
#       end

#       it 'should be interrupted by a paragraph' do
#         expect(process "    foo\nbar").to eq "<pre><code>foo\n</code></pre>\n<p>bar</p>"
#       end

#       it 'should not interrupt or be interrupted by any other block' do
#         expect(process "# Header\n    foo\nHeader\n------\n    foo\n----").to eq(
#           "<h1>Header</h1>\n<pre><code>foo\n</code></pre>\n<h2>Header</h2>\n<pre><code>foo\n</code></pre>\n<hr />")
#       end

#       it 'should not include outer blank lines' do
#         expect(process "\n    \n    foo\n    \n").to eq "<pre><code>foo\n</code></pre>"
#       end
#     end

#     describe 'fenced code blocks' do
#       it 'should parse backticks' do
#         expect(process "```\n<\n >\n```").to eq "<pre><code>&lt;\n &gt;\n</code></pre>"
#       end

#       it 'should parse tildes' do
#         expect(process "~~~\n<\n >\n~~~").to eq "<pre><code>&lt;\n &gt;\n</code></pre>"
#       end

#       it 'should parse only matching closing fences' do
#         expect(process "```\naaa\n~~~\n```").to eq("<pre><code>aaa\n~~~\n</code></pre>")
#         expect(process "~~~\naaa\n```\n~~~").to eq("<pre><code>aaa\n```\n</code></pre>")
#       end

#       it 'should parse only matching or longer closing fences' do
#         expect(process "````\naaa\n```\n``````").to eq("<pre><code>aaa\n```\n</code></pre>")
#         expect(process "~~~~\naaa\n~~~\n~~~~").to eq("<pre><code>aaa\n~~~\n</code></pre>")
#       end

#       it 'should closed unclosed blocks at eof' do
#         expect(process "```").to eq "<pre><code></code></pre>"
#         expect(process "`````\n\n```\naaa").to eq "<pre><code>\n```\naaa\n</code></pre>"
#         expect(process "> ```\n> aaa\n\nbbb").to eq "<pre><code>\n```\naaa\n</code></pre>"
#       end

#       it 'should parse empty lines as code blocks' do
#         expect(process "```\n\n  \n```").to eq "<pre><code>\n  \n</code></pre>"
#       end

#       it 'should parse empty code blocks' do
#         expect(process "```\n```").to eq "<pre><code></code></pre>"
#       end

#       it 'should match indentation inside code blocks' do
#         expect(process " ```\n aaa\naaa\n```").to eq("<pre><code>aaa\naaa\n</code></pre>")
#         expect(process "  ```\naaa\n  aaa\naaa\n  ```").to eq("<pre><code>aaa\naaa\naaa\n</code></pre>")
#         expect(process "   ```\n   aaa\n    aaa\n  aaa\n   ```").to eq("<pre><code>aaa\n aaa\naaa\n</code></pre>")
#       end

#       it 'should not parse too many spaces' do
#         expect(process "    ```\n    aaa\n    ```").to eq "<pre><code>```\naaa\n```\n</code></pre>"
#       end

#       it 'should parse indented closing fences' do
#         expect(process "```\naaa\n  ```").to eq("<pre><code>aaa\n</code></pre>")
#         expect(process "   ```\naaa\n  ```").to eq("<pre><code>aaa\n</code></pre>")
#       end

#       it 'should not parse closing fences with more than three spaces of indentation' do
#         expect(process "```\naaa\n    ```").to eq("<pre><code>aaa\n    ```\n</code></pre>")
#       end

#       it 'should not parse fences with internal spaces' do
#         expect(process "``` ```\naaa").to eq "<p><code></code>\naaa</p>"
#         expect(process "~~~~~~\naaa\n~~~ ~~").to eq "<pre><code>aaa\n~~~ ~~\n</code></pre>"
#       end

#       it 'should not requrie blank lines before or after other blocks' do
#         expect(process "foo\n```\nbar\n```\nbaz").to eq "<p>foo</p>\n<pre><code>bar\n</code></pre>\n<p>baz</p>"
#         expect(process "foo\n---\n~~~\nbar\n~~~\n# baz").to eq "<h2>foo</h2>\n<pre><code>bar\n</code></pre>\n<h1>baz</h1>"
#       end

#       it 'should parse info strings' do
#         expect(process "```ruby\ndef foo(x)\n  return 3\nend\n```").to eq(
#           "<pre><code class=\"language-ruby\">def foo(x)\n  return 3\nend\n</code></pre>")
#         expect(process "~~~~    ruby startline=3 $%@#$\ndef foo(x)\n  return 3\nend\n~~~~~~~").to eq(
#           "<<pre><code class=\"language-ruby\">def foo(x)\n  return 3\nend\n</code></pre>")
#         expect(process "````;\n````").to eq(
#           "<pre><code class=\"language-;\"></code></pre>")
#       end

#       it 'should not parse info strings with backticks' do
#         expect(process "``` aa ```\nfoo").to eq "<p><code>aa</code>\nfoo</p>"
#       end

#       it 'should not parse info strings after closing fences' do
#         expect(process "```\n``` aaa\n```").to eq "<pre><code>``` aaa\n</code></pre>"
#       end
#     end
#   end
# end
