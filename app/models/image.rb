class Image < ActiveRecord::Base
  has_many :face_features

  accepts_nested_attributes_for :face_features
end
