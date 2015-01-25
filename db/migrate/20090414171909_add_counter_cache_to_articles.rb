class AddCounterCacheToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :votes_count, :integer, :default => 0
  end

  def self.down
    remove_column :articles, :votes_count
  end
end
