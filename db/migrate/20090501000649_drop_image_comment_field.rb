class DropImageCommentField < ActiveRecord::Migration
  def self.up
    remove_column :images, :comments
  end

  def self.down
    add_column :images, :comments, :string
  end
end
