class AddModeratorToAbuse < ActiveRecord::Migration
  def self.up
    add_column :abuses, :moderator_id, :integer
  end

  def self.down
    remove_column :abuses, :moderator_id
  end
end