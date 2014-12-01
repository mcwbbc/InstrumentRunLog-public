class CreateBlanks < ActiveRecord::Migration
  
  def change
    create_table :blanks do |t|
      t.string :name
      t.integer :runs
      t.integer :gradient
      t.references :entry
      t.timestamps
    end #create_table
    
    sql = 'SELECT id, blank_runs, blank_gradient FROM entries'
    results = ActiveRecord::Base.connection.execute(sql).values
    results.each do |r|
      Blank.create!(:entry_id => r[0], :runs => r[1], :gradient => r[2], :name => 'blank')
    end
  end
end
