class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.string :site_url, :null => false
      t.string :feed_url, :null => false
      t.string :site_name, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :feeds
  end
end
