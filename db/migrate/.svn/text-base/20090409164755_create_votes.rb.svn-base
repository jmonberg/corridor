class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :article_id
      t.boolean :positive, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
