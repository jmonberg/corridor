class TotemEventToPolymorph < ActiveRecord::Migration
  def self.up
    remove_column :totem_events, :event_type
    remove_column :totem_events, :item_id
    add_column :totem_events, :action_id, :integer
    add_column :totem_events, :action_type, :string
  end

  def self.down
    remove_column :totem_events, :action_type
    remove_column :totem_events, :action_id
    add_column :totem_events, :item_id, :integer
    add_column :totem_events, :event_type, :string
  end
end
