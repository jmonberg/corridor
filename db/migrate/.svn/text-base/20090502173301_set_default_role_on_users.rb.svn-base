class SetDefaultRoleOnUsers < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE users ALTER COLUMN role SET DEFAULT 1"
  end

  def self.down
    execute "ALTER TABLE users ALTER COLUMN role DROP DEFAULT"
  end
end