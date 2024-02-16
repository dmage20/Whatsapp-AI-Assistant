# frozen_string_literal: true
require 'ruby/openai_pinecone'

# Configure the gem with your credentials
Ruby::OpenaiPinecone.configure do |config|
    config.openai_api_key = ENV["OPENAI_API_KEY"]
    config.pinecone_api_key = ENV["PINECONE_API_KEY"]
    config.pinecone_upsert_endpoint = "https://chatbot-g004ty9.svc.gcp-starter.pinecone.io/vectors/upsert"
    config.pinecone_query_endpoint = "https://chatbot-g004ty9.svc.gcp-starter.pinecone.io/query"
  end