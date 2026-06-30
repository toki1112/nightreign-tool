class StrategyPost < ApplicationRecord
  belongs_to :user
  belongs_to :boss

  validates :body, presence: true

  def editable?
    created_at >= 30.minutes.ago
  end
end
