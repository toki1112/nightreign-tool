class CreateMapPatterns < ActiveRecord::Migration[8.1]
  def change
    create_table :map_patterns do |t|
      t.references :night_lord, null: false, foreign_key: true
      t.references :terrain_change, null: false, foreign_key: true
      t.integer :pattern_no
      t.text :description

      t.timestamps
    end
  end
end
