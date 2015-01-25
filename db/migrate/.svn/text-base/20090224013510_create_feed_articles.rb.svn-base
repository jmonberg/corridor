class CreateFeedArticles < ActiveRecord::Migration
  def self.up
    create_table :feed_articles do |t|
      t.string :title
      t.text :content
      t.string :permalink
      t.datetime :date_posted
      t.integer :feed_id

      t.timestamps
    end
  end

  def self.down
    drop_table :feed_articles
  end
end
