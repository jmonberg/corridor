class CreateTaggs < ActiveRecord::Migration
  def self.up
    create_table :taggs do |t|
      t.string :title
      t.integer :taggable_id
      t.string :taggable_type
      t.string :user_id
      t.datetime :disabled_at

      t.timestamps
    end
  end

  def self.down
    drop_table :taggs
  end
end
