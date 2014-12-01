require 'test_helper'

class InstrumentTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "create new instrument" do
    instrument = Instrument.new
    instrument.name = 'TOF'
    assert instrument.save
  end
  
  test "should not creat new instrument" do
    instrument = Instrument.new
    assert !instrument.save
  end
end
