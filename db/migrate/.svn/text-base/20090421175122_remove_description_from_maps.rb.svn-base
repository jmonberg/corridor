class RemoveDescriptionFromMaps < ActiveRecord::Migration
  def self.up
    remove_column :maps, :description
	remove_column :maps, :author
	remove_column :maps, :title
	add_column :maps, :comment, :text
  end

  def self.down
    add_column :maps, :description, :text
	add_column :maps, :author, :string
	add_column :maps, :title, :string
	remove_column :maps, :comment
  end
end
