class AddSuspensionDatesToImages < ActiveRecord::Migration
  def self.up
    # Add two new columns needed for administrative purposes
    #   Date Suspended:   When was the Story suspended? (Null = Active)
    #   Suspension Notes: Why was this Story suspended?
    add_column :images, :suspended_at, :date
    add_column :images, :suspension_notes, :text
  end

  def self.down
    # Remove the same two fields.
    remove_column :images, :suspension_notes
    remove_column :images, :suspended_at
  end
end
