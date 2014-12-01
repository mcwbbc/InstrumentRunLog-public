class Category < ActiveRecord::Base
  has_many :samples
  has_many :price_models
  
  validates :name, :presence => true
  
  def self.categories_for_select
    Category.all.collect{|c| [c.name, c.id]}
  end
  
  def self.all_with_price_model
    a = []
    Category.all.each do |c|
      a.push(c) if c.has_current_price_model?
    end #Instrument.all.each
    return a
  end #self.instrument_with_price_model
  
  def has_current_price_model?
    price_models.each do |pm|
      return true if pm.current?
    end #price_models.each
    false
  end #has_current_price_model?
  
end
