class Blank < ActiveRecord::Base
  belongs_to :entry
  
  validates :name, :presence => true
  validates :runs, :presence => true, :numericality => true
  validates :gradient, :presence => true, :numericality => true
end
