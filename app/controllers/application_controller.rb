class ApplicationController < ActionController::API
  
  def set_user
    @user ||= User.find_or_create_by_request(request_parameters)
  end

  def request_parameters
    @request_parameters ||= begin
      parameters = request.parameters.transform_keys(&:underscore)
      parameters["phone"] = sanitize_phone(parameters.delete("from")) if parameters.key?("from")
      OpenStruct.new(parameters)
    end
  end

  def sanitize_phone(phone)
    # Remove prefix "whatsapp:"
    phone.gsub(/^whatsapp:/, '')
  end
end
