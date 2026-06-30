class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :strategy_posts, dependent: :destroy

  attr_accessor :password_confirmation

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true
end
