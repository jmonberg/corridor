class AddUserIdToMaps < ActiveRecord::Migration
  def self.up
    # Add User ID to the Maps table
    add_column :maps, :user_id, :integer
  end

  def self.down
    # Drop the User ID field.
    remove_column :maps, :user_id, :integer
  end
end
