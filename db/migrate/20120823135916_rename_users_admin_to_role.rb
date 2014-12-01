class RenameUsersAdminToRole < ActiveRecord::Migration
  def self.up
    rename_column :users, :admin, :role
  end

  def self.down
    rename_column :users, :role, :admin
  end
end
