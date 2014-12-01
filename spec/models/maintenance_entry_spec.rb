require 'spec_helper'

describe MaintenanceEntry, :validations => true do
  fixtures :projects, :categories, :instruments
  
  before :each do
    lab = Lab.create(:name => 'test project', :projects => [projects('testProject')])
    @user = User.create(:email => 'test@test.com', :password => 'test', :password_confirmation => 'test', :lab_id => lab.id)
    @maintenance = MaintenanceEntry.new
  end #before :each
  
  it "should require minutes" do
    @maintenance.should_not be_valid
    @maintenance.errors.messages.should include(:minutes => ["can't be blank"])
  end
  
  it "should require a user" do
    @maintenance.should_not be_valid
    @maintenance.errors.messages.should include(:user => ["can't be blank"])
  end
  
  it "should require an instrument" do
    @maintenance.should_not be_valid
    @maintenance.errors.messages.should include(:instrument => ["can't be blank"])
  end
  
  it "should require a date" do
    @maintenance.should_not be_valid
    @maintenance.errors.messages.should include(:date_conducted => ["can't be blank"])
  end
  
  it "should be valid" do
    valid_maintenance = MaintenanceEntry.new(:user => @user,
                                          :minutes => 600,
                                          :date_conducted => Date.today.to_s,
                                          :instrument => instruments('ltq'))
    valid_maintenance.should be_valid
  end
  
  it "should be valid when hours entered" do
    valid_maintenance = MaintenanceEntry.new(:user => @user,
                                          :hours => 60,
                                          :date_conducted => Date.today.to_s,
                                          :instrument => instruments('ltq'))
    valid_maintenance.should be_valid
  end
  
  it "should return 1 hour of maintenance" do
    valid_maintenance = MaintenanceEntry.new(:user => @user,
                                          :minutes => 600,
                                          :date_conducted => Date.today.to_s,
                                          :instrument => instruments('ltq'))
    
    valid_maintenance.hours.should eq(10)
  end
end
