class CreateAbuses < ActiveRecord::Migration
  def self.up
    # Create a new polymorphic table to track reports of abuse.
    create_table :abuses do |t|
      t.string  :abused_type
      t.integer :abused_id
      t.integer :reporting_user_id
      t.text    :notes
      t.integer :abuse_count, :default => 0 

      t.timestamps
    end
  end

  def self.down
    # Delete the abuse table.
    drop_table :abuses
  end
end