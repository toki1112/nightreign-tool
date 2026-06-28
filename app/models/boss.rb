class Boss < ApplicationRecord
  has_many :map_objects, dependent: :destroy
  has_many :strategy_posts, dependent: :destroy
end
