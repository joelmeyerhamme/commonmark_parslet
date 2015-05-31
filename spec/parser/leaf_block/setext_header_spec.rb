require './spec/spec_helper'
Bundler.require :develop

describe CommonMark::Parser::LeafBlock::SetextHeader do
  it 'should parse h1' do
    # byebug
    is_expected.to parse("Foo *bar*\n=========")
  end

  it 'should parse h2' do
    is_expected.to parse("Foo *bar*\n---------")
  end

  it 'should parse underlining of any length' do
    is_expected.to parse("Foo\n-------------------------")
    is_expected.to parse("Foo\n=")
  end

  it 'should parse leading spaces' do
    is_expected.to parse("   Foo\n---")
    is_expected.to parse("  Foo\n-----")
    is_expected.to parse("  Foo\n  ===")
  end

  it 'should not parse indented headers' do
    pending 'inline not yet implemented'
    is_expected.not_to parse("    Foo\n    ---")
    is_expected.not_to parse("    Foo\n---")
  end

  it 'should parse trailing spaces' do
    is_expected.to parse("Foo\n   ----      ")
  end

  it 'should not parse indented underlines' do
    is_expected.not_to parse("Foo\n    ---")
  end

  it 'should not parse underlines with internal spaces' do
    is_expected.not_to parse("Foo\n= =")
    is_expected.not_to parse("Foo\n--- -")
  end

  it 'should take preference over inlines' do
    pending 'doc, paragraph not yet implemented, move to doc'
    is_expected.to parse("`Foo\n----\n`")
    is_expected.to parse('<a title="a lot\n---\nof dashes"/>')
  end

  it 'should not parse lazy continuation lines' do
    pending 'quotations, lists, lazy cont. not yet implemented'
    is_expected.not_to parse("> Foo\n---")
    is_expected.not_to parse("- Foo\n---")
  end

  it 'should not interrupt a paragraph' do
    is_expected.not_to parse("Foo\nBar\n---")
    is_expected.not_to parse("Foo\nBar\n===")
  end

  it 'setext header should not require leading or trailing blank lines' do
    pending 'document and paragraph not yet implemented, move to document'
    is_expected.to parse("---\nFoo\n---\nBar\n---\nBaz")
  end

  it 'should not be empty' do
    is_expected.not_to parse("\n====")
  end

  it 'should not contain anything than a paragraph' do
    pending 'paragraph, lists, blocks, quotations not yet implemented'
    is_expected.not_to parse("---\n---")
    is_expected.not_to parse("- foo\n-----")
    is_expected.not_to parse("    foo\n---")
    is_expected.not_to parse("> foo\n-----")
  end

  it 'should parse escaped control sequences' do
    is_expected.to parse("\> foo\n------")
  end
end
