class TwilioController < ApplicationController
	include Webhookable
	include UserHandling
	include HandleMedia
	include HandleQuery
	before_action :set_user, only: [:answer]

	def answer
		if request_parameters.num_media.to_i > 0
			upload_pdf(@user)
		else
			query_response(request_parameters)
		end
	end
end