module Webhookable
	extend ActiveSupport::Concern
    
	def set_header
		response.headers["Content-Type"] = "text/xml"
	end

	def render_twiml(response)
		response.to_s
	end
    
end
    