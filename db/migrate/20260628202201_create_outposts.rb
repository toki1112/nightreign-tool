class CreateOutposts < ActiveRecord::Migration[8.1]
  def change
    create_table :outposts do |t|
      t.string :name
      t.string :icon
      t.integer :outpost_attribute

      t.timestamps
    end
  end
end
