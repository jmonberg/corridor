class AddRoleToUsers < ActiveRecord::Migration
  def self.up
    # Add three new columns needed for administrative purposes
    #   User Role:        User, Moderator, Admin
    #   Date Suspended:   When was the User account suspended? (Null = Active)
    #   Suspension Notes: Why was this user suspended?
    change_table :users do |t|
      t.string  :role
      t.date    :suspended_at     
      t.text    :suspension_notes
    end
  end

  def self.down
    # Remove the same three fields.
    change_table :users do |t|
      t.remove :role, :suspended_at, :suspension_notes
    end
  end
end