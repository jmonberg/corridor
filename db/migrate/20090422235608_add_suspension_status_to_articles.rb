class AddSuspensionStatusToArticles < ActiveRecord::Migration
  def self.up
    # Add a new column to keep track of the Article's Suspension Status.
    add_column    :articles, :suspension_status, :string
  end

  def self.down
    # Drop the column used to keep track of the Article's Suspension Status.
    remove_column :articles, :suspension_status
  end
end