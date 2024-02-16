module LanguageModels
  class Assistant

    attr_reader :client, :query, :phone

    def initialize(request_parameters)
      @client = Ruby::OpenaiPinecone::Client
      @query = request_parameters.body
      @phone = request_parameters.from
    end

    def provide_response
      response = OpenAI::Client.new.completions(
        parameters: {
          model: "gpt-3.5-turbo-instruct",
          prompt: prompt,
          temperature: 0.2,
          max_tokens: 500,
        }
      )

      # store_record(response)

      response['choices'][0]['text']
    end

    def source_text
      documents = client.query(query, namespace: "#{phone}")
      
      if documents["matches"]&.first&.dig("metadata", "text").to_s.empty?
        ""
      else
        documents["matches"].first["metadata"]["text"]
      end
    end

    def prompt
      @prompt ||= <<~PROMPT
        You are an AI assistant.

        You will be provided information from the repository of information under [Source]. The question will be provided under [Question]. You will answer the questions based on the repository of information.

        [Source]
        #{source_text}

        [Question]
        #{query}
      PROMPT
 
    end
    # todo try to give context of previous conversations
    def store_record(response)
      record = "query:#{query}, response:#{response['choices'][0]['text']}"
      vector = Ruby::OpenaiPinecone::Embeddings.generate(record)
      Ruby::OpenaiPinecone::Client.upsert("user_history", vector)
    end
  end
end