class Gram < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  mount_uploader :image, ImageUploader

  validates :caption, presence: true
  validates :image, presence: true
end
