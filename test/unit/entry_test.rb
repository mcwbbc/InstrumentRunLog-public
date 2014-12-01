require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "should create a new entry" do
    e = valid_entry
    
    assert e.save
  end
  
  test "should fail because of invalid project" do
    e = Entry.new(:user => users(:dummy), :blank_runs => 1, :blank_gradient => 60,
                                          :samples => samples(:one, :two))
    assert !e.save
    
    e.project = projects(:dummyProject)
    assert !e.save
  end
  
  test "should fail due to empty and invalid fields" do
    e = valid_entry
    e.blank_runs = nil
    assert !e.save
    e.blank_runs = 'test'
    assert !e.save
    
    e = valid_entry
    e.blank_gradient = nil
    assert !e.save
    e.blank_gradient = 'test'
    assert !e.save
    
    e = valid_entry
    e.samples = []
    assert !e.save
  end
  
  test "should require additional info" do
    e = valid_entry
    e.project = projects(:outsideProject)
    assert !e.save
    
    e.pi = 'test guy'
    e.department = 'test dept'
    assert e.save
  end
  
  test "should be able to edit entry" do
    e = entries(:one)
    assert e.update_attributes(:blank_runs => 2, :blank_gradient => 30)
  end
  
  test "should create entry with two samples and add pricing" do
    e = valid_entry
    e.samples << samples(:two)
    e.add_pricing_to_samples
    
    assert !e.samples.first.digest_price.nil?
  end
  
  private
  
  def valid_entry
    e = Entry.new
    
    e.user = users(:dummy)
    e.blank_runs = 1
    e.blank_gradient = 60
    e.project = projects(:testProject)
    e.instrument = instruments(:ltq).name
    e.samples = [samples(:one)]
    
    e
  end
    
end
