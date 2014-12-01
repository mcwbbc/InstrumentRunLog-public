class AddLoadingTimeToSamples < ActiveRecord::Migration
  def change
    add_column :samples, :loading_time, :integer 
  end
end
