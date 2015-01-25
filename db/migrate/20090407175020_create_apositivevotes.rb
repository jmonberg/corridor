class CreateApositivevotes < ActiveRecord::Migration
  def self.up
    create_table :apositivevotes do |t|
      t.integer :story_id
      t.integer :article_id

      t.timestamps
    end
  end

  def self.down
    drop_table :apositivevotes
  end
end
