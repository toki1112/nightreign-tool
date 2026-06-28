class CreateNightLords < ActiveRecord::Migration[8.1]
  def change
    create_table :night_lords do |t|
      t.string :name
      t.string :icon

      t.timestamps
    end
  end
end
