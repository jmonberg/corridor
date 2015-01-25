class CreateTotemEvents < ActiveRecord::Migration
  def self.up
    create_table :totem_events do |t|
      t.string :event_type
      t.string :author
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :totem_events
  end
end
