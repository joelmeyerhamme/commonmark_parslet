require './spec/spec_helper'

describe CommonMark::Parser::LeafBlock do
  describe "hrule" do
    it "should parse hrules" do
      is_expected.to parse("***")
      is_expected.to parse("---")
      is_expected.to parse("___")
    end

    context "HTML" do
      it "should parse asterisks as hrules" do
        pending "HTML not implemented"
        expect(subject.parse("***")).to eq("<hr />")
      end

      it "should parse dashes as hrules" do
        pending "HTML not implemented"
        expect(subject.parse("---")).to eq("<hr />")
      end

      it "should parse underscores as hrules" do
        pending "HTML not implemented"
        expect(subject.parse("___")).to eq("<hr />")
      end

      it "should not parse +++ as hrule" do
        pending "HTML not implemented"
        pending "paragraph not implemented"
        expect(subject.parse("+++")).to eq("<p>+++</p>")
      end

      it "should not parse === as hrule" do
        pending "HTML not implemented"
        pending "paragraph not implemented"
        expect(subject.parse("===")).to eq("<p>===</p>")
      end

      it "should not parse too few chars as hrule" do
        pending "HTML not implemented"
        pending "paragraph not implemented"
        expect(subject.parse("--")).to eq("<p>--</p>")
        expect(subject.parse("__")).to eq("<p>__</p>")
        expect(subject.parse("**")).to eq("<p>**</p>")
      end

      it "should allow leading spaces" do
        pending "HTML not implemented"
        expect(subject.parse(" ***\n  ***\n   ***")).to eq("<hr />\n<hr />\n<hr />")
      end

      it "should not allow indented hrules" do
        pending "HTML not implemented"
        pending "code blocks not implemented"
        expect(subject.parse("    ***")).to eq("<pre><code>***\n</code></pre>")
      end

      it "should allow trailing spaces" do
        pending "HTML not implemented"
        expect(subject.parse("- - - -    ")).to eq("<hr />")
      end

      it "should allow more than three chars" do
        pending "HTML not implemented"
        expect(subject.parse("________________________________")).to eq("<hr />")
      end

      it "should allow spaces between chars" do
        pending "HTML not implemented"
        expect(subject.parse(" - - -")).to                eq("<hr />")
        expect(subject.parse(" **  * ** * ** * **")).to   eq("<hr />")
        expect(subject.parse("-     -      -      -")).to eq("<hr />")
      end

      it "should not allow any other chars" do
        pending "HTML not implemented"
        pending "paragraph not implemented"
        expect(subject.parse("_ _ _ _ a")).to eq("<p>_ _ _ _ a</p>")
        expect(subject.parse("a------")).to   eq("<p>a------</p>")
        expect(subject.parse("---a---")).to   eq("<p>---a---</p>")
      end

      it "should not allow different chars" do
        pending "HTML not implemented"
        pending "paragraph not implemented"
        expect(subject.parse(" *-*")).to eq("<p><em>-</em></p>")
      end

      it "should not require leading/trailing blank lines" do
        pending "HTML not implemented"
        pending "lists not implemented"
        expect(subject.parse("- foo\n***\n- bar")).to
          eq("<ul>\n<li>foo</li>\n</ul>\n<hr />\n<ul>\n<li>bar</li>\n</ul>")
      end

      it "should interrupt a paragraph" do
        pending "HTML not implemented"
        pending "paragraph not implemented"
        expect(subject.parse("Foo\n***\nbar")).to
          eq("<p>Foo</p>\n<hr />\n<p>bar</p>")
      end

      it "should not take precedence to a setext header" do
        pending "HTML not implemented"
        pending "paragraph/heading not implemented"
        expect(subject.parse("Foo\n---\nbar")).to eq("<h2>Foo</h2>\n<p>bar</p>")
      end

      it "should take precedence to a list item" do
        pending "HTML not implemented"
        pending "lists not implemented"
        expect(subject.parse("* Foo\n* * *\n* Bar")).to
          eq("<ul>\n<li>Foo</li>\n</ul>\n<hr />\n<ul>\n<li>Bar</li>\n</ul>")
      end
    end
  end
end
