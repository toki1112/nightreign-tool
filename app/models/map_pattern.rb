class MapPattern < ApplicationRecord
  belongs_to :night_lord
  belongs_to :terrain_change

  has_many :map_objects, dependent: :destroy
end
