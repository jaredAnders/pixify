class Gram < ActiveRecord::Base
  belongs_to :user
  mount_uploader :image, ImageUploader

  validates :caption, presence: true
end
