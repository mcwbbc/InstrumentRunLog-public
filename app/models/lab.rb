class Lab < ActiveRecord::Base
  has_and_belongs_to_many :projects, :order => 'name'
  has_many :users
  
  validates :name, :presence => true
  validate :lab_should_have_projects
  
  def lab_should_have_projects
    errors.add(:id, "must have at least one project assigned") if projects.empty?
  end
end
