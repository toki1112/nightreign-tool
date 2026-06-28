class TerrainChange < ApplicationRecord
  has_many :map_patterns, dependent: :destroy
end
