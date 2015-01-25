class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string :title
      t.integer :user_id
      t.string :comments

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
