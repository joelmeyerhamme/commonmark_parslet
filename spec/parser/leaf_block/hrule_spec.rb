require './spec/spec_helper'

describe CommonMark::Parser::LeafBlock::Hrule do
  it 'should parse hrules' do
    is_expected.to parse('***')
    is_expected.to parse('---')
    is_expected.to parse('___')
  end

  context 'HTML' do
    it 'should parse asterisks as hrules' do
      is_expected.to parse('***')
    end

    it 'should parse dashes as hrules' do
      is_expected.to parse('---')
    end

    it 'should parse underscores as hrules' do
      is_expected.to parse('___')
    end

    it 'should not parse +++ as hrule' do
      is_expected.not_to parse('+++')
    end

    it 'should not parse === as hrule' do
      is_expected.not_to parse('===')
    end

    it 'should not parse too few chars as hrule' do
      is_expected.not_to parse('--')
      is_expected.not_to parse('__')
      is_expected.not_to parse('**')
    end

    it 'should allow leading spaces' do
      is_expected.to parse(' ***')
      is_expected.to parse('  ***')
      is_expected.to parse('   ***')
    end

    it 'should not allow indented hrules' do
      is_expected.not_to parse('    ***')
    end

    it 'should allow trailing spaces' do
      is_expected.to parse('- - - -    ')
    end

    it 'should allow more than three chars' do
      is_expected.to parse('________________________________')
    end

    it 'should allow spaces between chars' do
      is_expected.to parse(' - - -')
      is_expected.to parse(' **  * ** * ** * **')
      is_expected.to parse('-     -      -      -')
    end

    it 'should not allow any other chars' do
      is_expected.not_to parse('_ _ _ _ a')
      is_expected.not_to parse('a------')
      is_expected.not_to parse('---a---')
    end

    it 'should not allow different chars' do
      is_expected.not_to parse(' *-*')
    end

    context 'document' do
      it 'should not require leading/trailing blank lines' do
        pending 'lists not yet implemented'
        is_expected.to parse("- foo\n***\n- bar")
      end

      it 'should interrupt a paragraph' do
        pending 'paragraphs not yet implemented'
        is_expected.to parse("Foo\n***\nbar")
      end

      it 'should not take precedence to a setext header' do
        pending 'headers not yet implemented'
        is_expected.to parse("Foo\n---\nbar")
      end

      it 'should take precedence to a list item' do
        pending 'lists not yet implemented'
        is_expected.to parse("* Foo\n* * *\n* Bar")
      end
    end
  end
end
