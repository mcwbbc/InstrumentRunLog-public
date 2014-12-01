class Project < ActiveRecord::Base
  has_and_belongs_to_many :labs
  
  validates :name, :presence => true
  
  
end
