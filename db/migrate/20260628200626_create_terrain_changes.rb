class CreateTerrainChanges < ActiveRecord::Migration[8.1]
  def change
    create_table :terrain_changes do |t|
      t.string :name

      t.timestamps
    end
  end
end
