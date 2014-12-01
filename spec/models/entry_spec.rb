require 'spec_helper'


describe Entry do
  fixtures :projects, :categories, :instruments
  
  before :each do
    lab = Lab.create(:name => 'test project', :projects => [projects('testProject'), projects(:additional)])
    user = User.create(:email => 'test@test.com', :password => 'test', :password_confirmation => 'test', :lab_id => lab.id)
    @valid_entry = Entry.new(:lab_id => lab.id, :project_id => projects('testProject').id, :user_id => user.id)
    @valid_entry.instrument = instruments('ltq').name
    #@valid_entry.blank_runs = 1
    #@valid_entry.blank_gradient = 10
    @valid_entry.blanks << Blank.create!(:name => 'blank', :runs => 1, :gradient => 10)
    @valid_entry.date_run = Date.today.to_s
    @valid_entry.samples << Sample.create(:digests => 2,
                                          :runs => 2,
                                          :gradient => 10,
                                          :sample_price => 2,
                                          :digest_price => 3,
                                          :hour_price => 7,
                                          :category => categories('testing').name,
                                          :name => 'test sample')
    price_model = PriceModel.create(:instrument_id => instruments('ltq').id,
                                  :category_id => categories('testing').id,
                                  :sample_price => 10,
                                  :digest_price => 7,
                                  :hour_price => 3,
                                  :effective_date => Date.today,
                                  :retire_date => Date.today + 365)
   pm_old = PriceModel.create(:instrument_id => instruments('ltq').id,
                              :category_id => categories('testing').id,
                              :sample_price => 15,
                              :digest_price => 8,
                              :hour_price => 7,
                              :effective_date => Date.today - 365,
                              :retire_date => Date.today - 1)
  end
  
  it "should be valid" do
    @valid_entry.should be_valid
  end
  
  it "should not change the sample's name" do
    name = @valid_entry.samples.first.name
    @valid_entry.instrument = 'tester'
    @valid_entry.save
    @valid_entry.samples.first.name.should eq(name)
  end
  
  it "sample should always have a price" do
    @valid_entry.save
    @valid_entry.samples.first.sample_price.should_not be_nil
    @valid_entry.add_pricing_to_samples
    @valid_entry.samples.first.sample_price.should_not be_nil
  end
  
  it "should have an sample price of 15" do
    @valid_entry.save
    @valid_entry.date_run = Date.today - 10
    @valid_entry.save
    @valid_entry.add_pricing_to_samples
    @valid_entry.samples.first.sample_price.should eq(15.0)
  end
  
  it "sample price should be set after adding new sample" do
    @valid_entry.samples << Sample.new(:digests => 2,
                              :runs => 2,
                              :gradient => 10,
                              :category => categories('testing').name,
                              :name => 'second sample')
    @valid_entry.add_pricing_to_samples
    @valid_entry.samples.should have(2).items
    @valid_entry.samples.each do |s|
      s.sample_price.should eq(10.0)
    end
  end
  
  it "should not return unbillable entries" do
    @valid_entry.unbillable = true
    @valid_entry.save
    Entry.find_ready_for_invoice.should be_empty
  end
  
  it "should retuen a billable entry" do
    @valid_entry.save
    Entry.find_ready_for_invoice.should have(1).item
  end
  
  it "should not be valid due to missing additional information" do
    @valid_entry.project = projects(:additional)
    @valid_entry.should_not be_valid
  end
  
  it "should now be valid once additional information is added" do
    @valid_entry.project = projects(:additional)
    @valid_entry.purchase_order = '1234'
    @valid_entry.pi = 'Dr. Suesse'
    @valid_entry.department = 'Laughs'
    @valid_entry.should be_valid
  end
  
end #describe Entry

describe Entry, :calculations => true do
  fixtures :projects, :categories, :instruments
  
  before :each do
    lab = Lab.create(:name => 'test project', :projects => [projects('testProject'), projects(:additional)])
    user = User.create(:email => 'test@test.com', :password => 'test', :password_confirmation => 'test', :lab_id => lab.id)
    @valid_entry = Entry.new(:lab_id => lab.id, :project_id => projects('testProject').id, :user_id => user.id)
    @valid_entry.instrument = instruments('ltq').name
    #@valid_entry.blank_runs = 2
    #@valid_entry.blank_gradient = 5
    @valid_entry.blanks << Blank.create!(:name =>  'blank', :runs => 2, :gradient => 5)
    @valid_entry.date_run = Date.today.to_s
    @valid_entry.samples << Sample.create(:digests => 2,
                                          :runs => 2,
                                          :gradient => 10,
                                          :loading_time => 100,
                                          :sample_price => 2,
                                          :digest_price => 3,
                                          :hour_price => 7,
                                          :category => categories('testing').name,
                                          :name => 'test sample')
    @valid_entry.samples << Sample.create(:digests => 2,
                                          :runs => 2,
                                          :gradient => 10,
                                          :loading_time => 100,
                                          :sample_price => 2,
                                          :digest_price => 3,
                                          :hour_price => 7,
                                          :category => categories('testing').name,
                                          :name => 'test sample')
                                          
    price_model = PriceModel.create(:instrument_id => instruments('ltq').id,
                                  :category_id => categories('testing').id,
                                  :sample_price => 10,
                                  :digest_price => 7,
                                  :hour_price => 3,
                                  :effective_date => Date.today,
                                  :retire_date => Date.today + 365)

    @valid_entry.save
  end
  
  it "should have a total time of 50" do
    @valid_entry.total_run_time.should eq(250)
  end
  
  it "should have a billable run time of 40" do
    @valid_entry.billable_run_time.should eq(40)
  end
  
  it "should have a blank run time of 10" do
    @valid_entry.blank_run_time.should eq(10)
  end
  
  
end #describe Entry
