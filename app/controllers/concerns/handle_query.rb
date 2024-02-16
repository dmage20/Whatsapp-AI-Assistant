module HandleQuery
  def query_response(request_parameters)
    twiml = Twilio::TwiML::MessagingResponse.new do |r|
			r.message(body: LanguageModels::Assistant.new(request_parameters).provide_response)
		end

    set_header		
		render xml: twiml.to_s
  end
end