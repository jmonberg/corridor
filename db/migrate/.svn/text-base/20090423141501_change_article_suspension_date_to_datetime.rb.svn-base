class ChangeArticleSuspensionDateToDatetime < ActiveRecord::Migration
  def self.up
    # Change the suspension status date field to a date time field
    change_column :articles, :suspended_at, :datetime
  end

  def self.down
    # Revert the same field back to a date field
    change_column :articles, :suspended_at, :date
  end
end