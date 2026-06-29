class RenameOutpostAttributeAndAddElementToOutposts < ActiveRecord::Migration[8.1]
  def change
    rename_column :outposts, :outpost_attribute, :outpost_type
    add_column :outposts, :element_type, :integer
    add_column :outposts, :element_icon, :string
  end
end
