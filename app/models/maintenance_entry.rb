class MaintenanceEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :instrument
  
  validates :user, :presence => true
  validates :instrument, :presence => true
  validates :minutes, :presence => true
  validates :date_conducted, :presence => true
  
  def self.instrument_usage
    sum(:minutes, :group => [:instrument_id, :date_conducted])
  end #self.instrument_usage
  
  def hours
    minutes/60.0
  end
  
  def hours=(h)
    self.minutes = h.to_f*60
  end
end
