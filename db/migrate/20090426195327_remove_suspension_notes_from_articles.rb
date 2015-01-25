class RemoveSuspensionNotesFromArticles < ActiveRecord::Migration
  def self.up
    remove_column :articles, :suspension_notes
  end

  def self.down
    add_column :articles, :suspension_notes, :text
  end
end