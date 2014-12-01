module EntriesHelper
  
  def names_with_add_req
    Project.find_all_by_additional_required(true).collect{|p| p.name}
  end
  
  def categories_available
    categories = Category.all_with_price_model.collect{|c| [c.name, c.name]}
    categories.unshift [' ', '']
    categories
  end
  
  def projects_available
    projects = current_user.lab.projects.order(:name).collect{|p| [p.name, p.id]}
    projects.unshift [' ', '']
    projects
  end
  
  def run_log_header_array
     ['Date','Operator','Project',
       'PI','Dept.','Instrument','Run Time(Min)',
       'Billable Run Time(Min)','Billable Digests',
       'Samples', 'Total Runs']
   end
   
   def run_log_text_header_array
     ['Date','Operator','Project',
      'PI','Dept.','Purchase Order','Instrument','Run Time(Min)',
      'Billable Run Time(Min)','Billable Digests',
      'Samples', 'Total Runs', 'Blanks',
      'Amount Due','Unbillable']
   end
end
