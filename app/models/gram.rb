class Gram < ActiveRecord::Base
  validates :caption, presence: true
end
