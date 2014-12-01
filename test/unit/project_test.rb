require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "should create project" do
    p = Project.new(:name => 'test')
    assert p.save
  end
  
  test "should not create a project" do
    p = Project.new
    assert !p.save
  end
end
