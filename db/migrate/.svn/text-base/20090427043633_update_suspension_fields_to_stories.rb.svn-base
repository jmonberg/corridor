class UpdateSuspensionFieldsToStories < ActiveRecord::Migration
  def self.up
    change_column :stories, :suspended_at,      :datetime
    add_column    :stories, :suspension_status, :string
    remove_column :stories, :suspension_notes
  end

  def self.down
    change_column :stories, :suspended_at,     :date
    add_column    :stories, :suspension_notes, :text
    remove_column :stories, :suspension_status
  end
end