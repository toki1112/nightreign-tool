class Outpost < ApplicationRecord
  has_many :map_objects, dependent: :destroy
end
