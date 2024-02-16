module LanguageModels
  class Chat
    TEMPERATURE=0.7 #Mearure of creativity in respnse
    MODEL="gpt-3.5-turbo".freeze
    ROLE="user"
    
    attr_reader :text, :client
    
    def initialize(text)
      @text = text
      @client = OpenAI::Client.new 
    end

    def provide_response
      fetch_response
    end

    def parameters
      {
        model: MODEL, # Required.
        messages: [{ role: ROLE, content: text}], # Required.
        temperature: TEMPERATURE,
      }  
    end

    def fetch_response
      response = client.chat(parameters: parameters)
      if response
        response.dig("choices", 0, "message", "content")
      else
        "Sorry, no response :( "
      end
    end
    
  end
end