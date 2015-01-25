class AddCategoryToMaps < ActiveRecord::Migration
  def self.up
    add_column :maps, :category, :string
  end

  def self.down
    remove_column :maps, :category
  end
end
