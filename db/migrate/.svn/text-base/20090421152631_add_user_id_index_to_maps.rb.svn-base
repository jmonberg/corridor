class AddUserIdIndexToMaps < ActiveRecord::Migration
  def self.up
    # Add User ID Index on the Maps table
    add_index  :maps, :user_id
  end

  def self.down
    # Drop the User ID index.
    remove_index :maps, :user_id
  end
end
