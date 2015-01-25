class AddSuspensionDatesToStories < ActiveRecord::Migration
  def self.up
    # Add two new columns needed for administrative purposes
    #   Date Suspended:   When was the Story suspended? (Null = Active)
    #   Suspension Notes: Why was this Story suspended?
    add_column :stories, :suspended_at, :date
    add_column :stories, :suspension_notes, :text
  end

  def self.down
    # Remove the same two fields.
    remove_column :stories, :suspension_notes
    remove_column :stories, :suspended_at
  end
end