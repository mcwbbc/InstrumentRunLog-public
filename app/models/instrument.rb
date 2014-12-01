class Instrument < ActiveRecord::Base
  has_many :entries
  has_many :price_models
  
  validates :name, :presence => true, :uniqueness => true
  
  def self.instruments_for_select
    Instrument.all.collect{|i| [i.name, i.id]}
  end
  
  def self.all_with_price_model
    a = []
    Instrument.all.each do |i|
      a.push(i) if i.has_current_price_model?
    end #Instrument.all.each
    return a
  end #self.instrument_with_price_model
  
  def has_current_price_model?
    price_models.each do |pm|
      return true if pm.current?
    end #price_models.each
    false
  end #has_current_price_model?
  
  def categories
    c = Hash.new
    price_models.where(["effective_date <= ? AND ? <= retire_date", Date.today, Date.today]).each {|p| c[p.category.id] = p.category }
    c.values
  end
  
end
