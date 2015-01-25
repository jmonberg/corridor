class AddRefIdToMaps < ActiveRecord::Migration
  def self.up
    add_column :maps, :ref_id, :integer
  end

  def self.down
    remove_column :maps, :ref_id
  end
end
