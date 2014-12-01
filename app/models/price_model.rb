class PriceModel < ActiveRecord::Base
  belongs_to :category
  belongs_to :instrument
  
  validates :category_id, :presence => true
  validates :instrument_id, :presence => true
  validates :sample_price, :presence => true
  validates :digest_price, :presence => true
  validates :hour_price, :presence => true
  validates :effective_date, :presence => true
  validates :retire_date, :presence => true
  validate :unique_effective
  validate :effective_before_retire

  
  
  def self.find_not_retired
    self.where("retire_date IS NULL or current_date - retire_date < 1").order("retire_date DESC")
  end
  
  def self.find_current_pricing(date_run, instrument, category)
    c = Category.find_by_name(category).id
    i = Instrument.find_by_name(instrument).id
                                
    pm = PriceModel.find_by_sql("SELECT pm.sample_price, pm.digest_price, pm.hour_price
                                FROM price_models pm
                                WHERE pm.category_id = #{c}
                                AND pm.instrument_id = #{i}
                                AND ('#{date_run}' - effective_date) >= 0
                                AND ('#{date_run}' - retire_date) < 1")
    pm.pop
  end   
  
  def current?
    today = Date.today
    (effective_date <= today and today <= retire_date) ? true : false
  end
  
  private
  
  def unique_effective
    return unless errors.empty?
    
    sql = "SELECT effective_date, retire_date
            FROM price_models
            WHERE category_id = #{category.id}
            AND instrument_id = #{instrument.id}"
                                
    sql += " AND id != #{id}" unless id.nil? #ignores itself for updates
    
    pm = PriceModel.find_by_sql sql
                                
    error_count = 0
    pm.each do |t|
      if( effective_date < t.retire_date and retire_date > t.effective_date)
        error_count =+ 1
      end         
    end
    
    if error_count > 0
      errors.add(:id, "dates conflicts with #{error_count} existing model(s)")
    end
  end #unique_effective
  
  def effective_before_retire
    errors.add(:id, "retire date cannot be before effective date") if effective_date >= retire_date
  end #effective_before_retire
  
end
