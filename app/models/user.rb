class User < ActiveRecord::Base
  validates :name, presence: true
  validates :phone, presence: true, uniqueness: true

  def self.find_or_create_by_request(request)
    user = find_by(phone: request.phone)
    return user if user

    create(phone: request.phone, name: request.profile_name)
  end
end