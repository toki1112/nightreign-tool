class Boss < ApplicationRecord
  has_many :map_objects, dependent: :destroy
  has_many :strategy_posts, dependent: :destroy

  # runsackで検索していいカラムの指定
  def self.ransackable_attributes(_auth_object = nil)
    %w[name]
  end
end
