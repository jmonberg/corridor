class CreateMaps < ActiveRecord::Migration
  def self.up
    create_table :maps do |t|
      t.decimal :latitude
      t.decimal :longitude
      t.string :title
      t.string :author
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :maps
  end
end
