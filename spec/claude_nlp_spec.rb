# frozen_string_literal: true

require 'claude_nlp'

RSpec.describe ClaudeNLP do
  let(:nlp) { described_class.new }
  let(:theme) { 'flowers' }
  let(:description) { 'A beautiful bouquet of flowers in full bloom.' }

  before do
    ENV['ANTHROPIC_API_KEY'] = 'test_api_key'
  end

  describe '#description_matches_theme?' do
    it 'returns true when description relates to the theme' do
      allow_any_instance_of(Anthropic::Client).to receive(:messages).and_return(
        { 'content' => [{ 'text' => 'Yes, this description relates' }] }
      )

      expect(nlp.description_matches_theme?(description, theme)).to be true
    end

    it 'returns false when description does not relate to the theme' do
      allow_any_instance_of(Anthropic::Client).to receive(:messages).and_return(
        { 'content' => [{ 'text' => 'No, this description does not relate' }] }
      )

      expect(nlp.description_matches_theme?(description, theme)).to be false
    end
  end
end
