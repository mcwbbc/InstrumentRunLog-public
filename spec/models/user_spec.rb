require 'spec_helper'

describe User do
  
  before :each do
    project = Project.create(:name => 'test project')
    lab = Lab.create(:name => 'test project', :projects => [project])
    @user = User.create(:email => 'test@test.com', :password => 'test', :password_confirmation => 'test', :lab_id => lab.id)
  end
  
  it "should not be a manager" do
    @user.manager?.should be_falsey
  end
  
  it "should not be administrator" do
    @user.admin?.should be_falsey
  end
  
  it "should be a manager" do
    @user.role = 2 #manager code
    @user.manager?.should be_truthy
  end
  
  it "should not be a administrator" do
    @user.role = 2 #manager code
    @user.admin?.should be_falsey
  end
  
  it "should be a administrator" do
    @user.role = 1 #admin code
    @user.admin?.should be_truthy
  end
  
  it "should also be a manager" do
    @user.role = 1 #admin code
    @user.manager?.should be_truthy
  end
  
  it "should not be a administrator" do
    @user.role = 0 #operator code
    @user.admin?.should be_falsey
  end
  
  it "should not be a manager" do
    @user.role = 0 #operator code
    @user.manager?.should be_falsey
  end
  
end
