require 'spec_helper'

describe Entry, :charts => true do
  fixtures :projects, :categories, :instruments, :samples
  
  before :each do
    lab = Lab.create(:name => 'test project', :projects => [projects('testProject'), projects(:additional)])
    user = User.create(:email => 'test@test.com', :password => 'test', :password_confirmation => 'test', :lab_id => lab.id)
    entry_info = {
      :lab_id => lab.id, :project_id => projects('testProject').id, :user_id => user.id,
      :instrument => instruments('ltq').name, :blank_runs => 2, :blank_gradient => 10,
      :blanks => [Blank.create!(:name => 'blank', :runs => 2, :gradient => 10)]
    }
    @valid_entry = Entry.new(entry_info)
    @valid_entry.date_run = Date.today.to_s
    
    @valid_entry_2 = Entry.new(entry_info)
    @valid_entry_2.date_run = Date.yesterday.to_s
    
    @valid_entry.samples = [samples(:one), samples(:two)]
    @valid_entry_2.samples = [samples(:three), samples(:four)]
                                          
    price_model = PriceModel.create(:instrument_id => instruments('ltq').id,
                                  :category_id => categories('testing').id,
                                  :sample_price => 10,
                                  :digest_price => 7,
                                  :hour_price => 3,
                                  :effective_date => Date.today,
                                  :retire_date => Date.today + 365)

    @valid_entry.save
    @valid_entry_2.save
  end #before
    
  it "should return a data structure" do
    Entry.instrument_usage.should eq({"LTQ" => {Date.yesterday.to_s(:number) => 60,
                                                Date.today.to_s(:number) => 60}})
  end
  
  it "should return canvasxpress data structure" do
    Entry.instrument_usage_past_year.should eq({"vars" => ["LTQ"],
                                            "smps" => [Date.yesterday,Date.today],
                                            "desc" => ["Minutes Run"],
                                            "data" => [[60,60]]})
  end
  
  it "should return a rollup of usage per instrument" do
    @valid_entry.save
    Entry.instrument_hours.should eq({"vars"=>["LTQ"], "data"=>[[2.0]], "smps"=>["Total Hours"]})
  end
  
  
end #describe Entry
