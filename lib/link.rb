class Link  < ActiveRecord::Base
  validates_presence_of :title, :description, :URL

  belongs_to :user
end
