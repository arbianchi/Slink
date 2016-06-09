class User < ActiveRecord::Base
  validates_presence_of :username, :password

  has_many :links
  has_many :recommendations
end
