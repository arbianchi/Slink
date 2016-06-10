class User < ActiveRecord::Base
  validates_presence_of :username
  validates_uniqueness_of :username
  validates_presence_of :password

  has_many :links
  has_many :recommendations
end
