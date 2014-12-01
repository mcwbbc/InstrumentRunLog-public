require 'test_helper'

class PriceModelTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "should create price model" do
    pm = PriceModel.new
    pm.instrument = instruments(:orbi)
    pm.category = categories(:internal)
    pm.digest_price = 0
    pm.sample_price = 0
    pm.hour_price = 50
    pm.effective_date = Date.today
    pm.retire_date = Date.today + 365
    assert pm.save
  end
  
  test "should not create price model" do
    pm = PriceModel.new
    assert !pm.save
    
    pm.instrument = instruments(:ltq)
    assert !pm.save
    
    pm.category = categories(:internal)
    assert !pm.save
    
    pm.digest_price = 0
    assert !pm.save
    
    pm.digest_price = nil
    pm.hour_price = 50
    assert !pm.save
  end
  
  test "should return valid price model" do
    pm = PriceModel.find_current_pricing('LTQ', 'Internal')
    
    assert !pm.nil?
  end
  
  test "should return error and not create price model" do
    i = Instrument.new 'MALDI'
    c = categories(:internal)
    pm = PriceModel.new
    pm.digest_price = 0
    pm.hour_price = 0
    pm.sample_price = 20
    pm.effective_date = Date.today + 365
    pm.retire_date = Date.today
    
    assert !pm.save
  end
end
