module ApplicationHelper
  def submit_or_cancel(form, name='Cancel')
    form.submit + " or " + link_back(name)
  end
  
  def link_back(name='Back')
    link_to(name, 'javascript:history.go(-1)', :class => 'cancel')
  end
  
  def instruments_available
    instruments = Instrument.all_with_price_model.collect{|i| [i.name, i.name]}
    instruments.unshift [' ', '']
    instruments
  end
  
end
