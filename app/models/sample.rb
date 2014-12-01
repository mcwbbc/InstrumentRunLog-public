class Sample < ActiveRecord::Base
  belongs_to :entry
  
  validates :digests, :presence => true
  validates :runs, :presence => true
  validates :gradient, :presence => true
  validates :category, :presence => true
  
  def billable_digests
    digest_price == 0 ? 0 : digests
  end
  
  def billable_time
    gradient * runs
  end
  
  def cost
    prep_cost + gradient_cost
  end
  
  def digest_cost
    digests * digest_price
  end
  
  def gradient_cost
    billable_time * hour_price / 60
  end
  
  def prep_cost
    digest_cost + sample_price
  end
  
  def unbilled_loading_time
    self.loading_time.nil? ? 0 : self.loading_time
  end
end
