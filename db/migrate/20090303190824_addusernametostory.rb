class Addusernametostory < ActiveRecord::Migration
  def self.up
    add_column :stories, :username, :string
  end

  def self.down
    remove_column :stories, :username, :string
  end
end
