require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "should create category" do
    category = Category.new
    
    category.name = 'Test'
    assert category.save
  end
  
  test "should not create category" do
    catgeory = Category.new
    assert !catgeory.save
  end
end
