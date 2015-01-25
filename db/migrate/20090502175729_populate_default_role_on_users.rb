class PopulateDefaultRoleOnUsers < ActiveRecord::Migration
  # Populate the default user role value (1) for any user without a user role value (Null).
  def self.up
    execute "UPDATE users SET role = 1 WHERE role is null;"
  end

  # Warning: Not reversible!
  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end