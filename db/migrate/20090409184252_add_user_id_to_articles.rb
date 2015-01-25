class AddUserIdToArticles < ActiveRecord::Migration
  def self.up
    # Add User ID to the Articles table so we can associate each article with a registered User.
    change_table :articles do |t|
      t.integer :user_id
      t.index   :user_id
    end
  end

  def self.down
    # Drop the User ID field.
    change_table :articles do |t|
      t.remove :user_id
    end
  end
end