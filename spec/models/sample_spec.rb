require 'spec_helper'


describe Sample do
  fixtures :projects, :categories, :instruments
  
  before :each do
    @sample = Sample.create(:digests => 2,
                            :runs => 2,
                            :gradient => 10,
                            :sample_price => 2,
                            :digest_price => 3,
                            :hour_price => 6,
                            :category => categories('testing').name,
                            :name => 'test sample')
  end #before
  
  it "should have billable_time equal to 20" do
    @sample.billable_time.should eq(20)
  end
  
  it "should have a digest cost equal to (6)" do
    @sample.digest_cost.should eq(6)
  end
  
  it "should have a gradient cost equal to (2)" do
    @sample.gradient_cost.should eq(2)
  end
  
  it "should have a total cost equal to (10)" do
    @sample.cost.should eq(10)
  end
end #describe Sample