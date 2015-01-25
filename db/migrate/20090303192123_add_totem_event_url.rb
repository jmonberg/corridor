class AddTotemEventUrl < ActiveRecord::Migration
  def self.up
    add_column :totem_events, :item_id, :integer
    add_column :totem_events, :title, :string
  end

  def self.down
    remove_column :totem_events, :item_id
    remove_column :totem_events, :title
  end
end
