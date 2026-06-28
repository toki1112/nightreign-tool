class CreateMapObjects < ActiveRecord::Migration[8.1]
  def change
    create_table :map_objects do |t|
      t.references :map_pattern, null: false, foreign_key: true
      t.references :boss, null: true, foreign_key: true
      t.references :outpost, null: true, foreign_key: true
      t.integer :floor
      t.string :position_name
      t.integer :x
      t.integer :y

      t.timestamps
    end
  end
end
