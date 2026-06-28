class NightLord < ApplicationRecord
  has_many :map_patterns, dependent: :destroy
end
