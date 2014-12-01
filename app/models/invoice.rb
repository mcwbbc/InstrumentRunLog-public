class Invoice < ActiveRecord::Base
  has_many :entries
  
  validate :has_entries_present?
  
  def to_text
    text = "Invoice:\t#{id}\n"
    text += "Created:\t#{created_at.to_date}\n"
    
    columns = ['Date', 'Researcher', 'Lab', 'Billable Digests', 
                'Billable Run Time(min)','Project', 'PI/Dept', 'Amount Due']
    text += columns.join("\t") + "\n"
    
    entries.each do |e|
      text += [e.created_at.to_date,
                e.user.email,
                e.user.lab.name,
                e.billable_digests,
                e.billable_run_time,
                e.project.name,
                e.pi_and_department,
                e.amount_due].join("\t") + "\n"
      text += "\tSamples:\n"
      text += "\tCategory\t# of Digests\t# of Runs\t#Gradient\n"
      e.samples.each do |s|
        text += "\t"
        text += [s.category, s.digests, s.runs, s.gradient].join("\t")
        text += "\n"
      end
    end
    (2...columns.length).each {text += "\t"}
    text += "Total Due:\t" + total_amount_due.to_s
    text
  end #to_text
  
  def total_amount_due
    entries.inject(0) {|sum, e| sum += e.amount_due}
  end
  
  private
  
  def has_entries_present?
    errors.add(:id, 'must have at least one entry') if entries.empty?
  end #has_entries_present
end
