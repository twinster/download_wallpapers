# frozen_string_literal: true

require 'anthropic'
require 'dotenv/load'

# ClaudeNLP is a class that provides methods for Natural Language Processing
# This class interacts with the Claude API to analyze text and provide
# insights based on the context defined by the user.
class ClaudeNLP
  def initialize
    @client = Anthropic::Client.new(access_token: ENV['ANTHROPIC_API_KEY'])
  end

  def description_matches_theme?(description, theme)
    prompt = "Does this description relate to the theme of '#{theme}'? Description: #{description}. Answer yes/no."

    response = @client.messages(
      parameters: {
        model: 'claude-3-haiku-20240307',
        messages: [{ role: 'user', content: prompt }],
        max_tokens: 5,
        stream: proc { |chunk| print chunk }
      }
    )

    response['content'].first['text'].downcase.start_with? 'yes'
  end
end
