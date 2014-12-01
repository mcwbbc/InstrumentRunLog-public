require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "should create invoice" do
    i = Invoice.new
    i.entries << entries(:one)
    assert i.save
  end
  
  test "should not create invoice" do
    i = Invoice.new
    assert !i.save
  end
  
end
