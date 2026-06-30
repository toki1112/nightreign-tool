class CreateStrategyPosts < ActiveRecord::Migration[8.1]
  def change
    create_table :strategy_posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :boss, null: false, foreign_key: true
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
