module MaintenanceEntriesHelper
  def instruments_for_select
    instruments = Instrument.all_with_price_model.collect{|i| [i.name, i.id]}
    instruments.unshift [' ', '']
    instruments
  end
end
