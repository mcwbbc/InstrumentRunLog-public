class CreateLabsProjects < ActiveRecord::Migration
  def self.up
    create_table :labs_projects, :id => false do |t|
      t.references :lab
      t.references :project
    end
  end

  def self.down
    drop_table :labs_projects
  end
end
