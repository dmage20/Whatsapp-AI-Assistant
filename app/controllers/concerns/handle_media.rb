require 'open-uri'
require 'mime-types'
module HandleMedia
  include Webhookable
  def success_message(num_media)
    twiml = Twilio::TwiML::MessagingResponse.new do |resp|
      body = num_media > 0 ? "Thanks for sending us #{num_media} file(s)!" : 'Send us a document!'
      resp.message body: body
    end
  
    set_header
    render xml: twiml.to_s
  end

  def upload_pdf(user)
    num_media = request.params['NumMedia'].to_i
    if num_media > 0
      (0..num_media).each do |i|
        content_type = params["MediaContentType#{i}"]
        return unless content_type == "application/pdf"
        media_url = params["MediaUrl#{i}"]
        file_id = media_url.split('/').last
        file_extension = MIME::Types[content_type].first.extensions.first
        file_name = "#{file_id}.#{file_extension}"

        file = open(media_url)
        reader = PDF::Reader.new(file)
        reader.pages.each do |page|
          text = page.text
          vector = Ruby::OpenaiPinecone::Embeddings.generate(text)
          Ruby::OpenaiPinecone::Client.upsert(
            "user_data_#{user.phone}", 
            vector, metadata: { "text": "#{text}"},
            namespace: "#{user.phone}"
          )
        end
        success_message(num_media)
      end
    end
  end
end