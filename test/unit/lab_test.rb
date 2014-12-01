require 'test_helper'

class LabTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "create new lab" do
    lab = Lab.new
    
    lab.name = 'Testing'
    lab.projects = [projects(:testProject), projects(:dummyProject)]
    
    assert lab.save
  end
  
  test "should not create new lab" do
    lab = Lab.new
    assert !lab.save
    
    lab.name = 'Testing'
    assert !lab.save
  end
  
end
