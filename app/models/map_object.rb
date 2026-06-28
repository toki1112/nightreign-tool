class MapObject < ApplicationRecord
  belongs_to :map_pattern
  belongs_to :boss, optional: true
  belongs_to :outpost, optional: true
end
