class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :category
      t.string :title
      t.string :author
      t.text :body
      t.text :tags
      t.string :imglink1
      t.string :imglink2
      t.string :caption1
      t.string :caption2

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
