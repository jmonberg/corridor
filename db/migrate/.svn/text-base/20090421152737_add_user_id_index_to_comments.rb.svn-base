class AddUserIdIndexToComments < ActiveRecord::Migration
  def self.up
    # Add User ID Index on the Comments table
    add_index  :comments, :user_id
  end

  def self.down
    # Drop the User ID index.
    remove_index :comments, :user_id
  end
end