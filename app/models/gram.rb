class Gram < ActiveRecord::Base
  belongs_to :user
  
  validates :caption, presence: true
end
