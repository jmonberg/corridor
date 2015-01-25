class AddSuspensionStatusToComments < ActiveRecord::Migration
  def self.up
    add_column    :comments, :suspension_status, :string
    remove_column :comments, :suspension_notes
  end

  def self.down
    add_column    :comments, :suspension_notes, :text
    remove_column :comments, :suspension_status
  end
end
