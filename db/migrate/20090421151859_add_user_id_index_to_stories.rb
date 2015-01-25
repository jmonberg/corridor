class AddUserIdIndexToStories < ActiveRecord::Migration
  def self.up
    # Add User ID to the Stories table
    add_column :stories, :user_id, :integer
    # Add User ID Index on the Stories table
    add_index  :stories, :user_id
  end

  def self.down
    remove_column :stories, :user_id
    # Drop the User ID index.
    remove_index :stories, :user_id
    # Drop the User ID field.
    remove_column :stories, :user_id
  end
end