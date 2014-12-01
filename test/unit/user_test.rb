require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "should create new user" do
    user = User.new
    
    user.email = 'test@email.com'
    user.password = 'test'
    user.password_confirmation = 'test'
    user.lab = labs(:test)
    
    assert user.save
  end
  
  test "should create new admin" do
    user = User.new
    
    user.email = 'admin@email.com'
    user.password = 'admin'
    user.password_confirmation = 'admin'
    user.lab = labs(:test)
    user.admin = 1
    
    assert user.save
  end
  
  test "should not create a new user" do
    user = User.new
    
    user.email = 'test@email.com'
    user.password = 'test'
    user.password_confirmation = 'wrong'
    
    assert !user.save #mismatch passwords
    
    user.password_confirmation = 'test'
    assert !user.save #no lab assignment
  end
  
  test "should update user" do
    user = users(:dummy)
    assert user.update_attributes(:password => 'test', :password_confirmation => 'test')
  end
  
  test "should not update user" do
    user = users(:dummy)
    assert !user.update_attributes(:password => 'test', :password_confirmation => 'wrong')
  end
end
