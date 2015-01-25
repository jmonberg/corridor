class AlterMapsDataType < ActiveRecord::Migration
  def self.up
    remove_column :maps, :latitude
    remove_column :maps, :longitude
    add_column :maps, :latitude, :decimal, :precision => 15, :scale => 10
    add_column :maps, :longitude, :decimal, :precision => 15, :scale => 10
  end

  def self.down
    remove_column :maps, :longitude
    remove_column :maps, :latitude
    add_column :maps, :longitude, :decimal
    add_column :maps, :latitude, :decimal
  end
end
