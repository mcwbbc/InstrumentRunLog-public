class Entry < ActiveRecord::Base
  belongs_to :user
  belongs_to :updated_by, :class_name => "User", :foreign_key => "updated_by_id"
  belongs_to :project
  belongs_to :invoice
  belongs_to :lab
  has_many :samples
  has_many :blanks
  
  accepts_nested_attributes_for :samples
  accepts_nested_attributes_for :blanks
  
  validates :user_id, :presence => true
  validates :project_id, :presence => true
  validate :valid_project?
#  validates :blank_runs, :presence => true, :numericality => true
#  validates :blank_gradient, :presence => true, :numericality => true
  validate :samples_present?
  validate :blanks_present?
  validates :instrument, :presence => true
  validates :date_run, :presence => true
  
  with_options :if => :additional_required? do |e|
    e.validates :purchase_order, :presence => true
    e.validates_presence_of :pi
    e.validates_presence_of :department
  end
  
  def self.find_ready_for_invoice
    where("invoice_id IS NULL AND unbillable IS NOT TRUE").order('date_run ASC')
  end
  
  def add_pricing_to_samples
    samples.each do |s|
      pm = PriceModel.find_current_pricing(date_run, instrument, s.category)
      return errors.add(:id, "price model not found for #{instrument} and #{s.category}") if pm.nil?
      s.sample_price = pm.sample_price
      s.digest_price = pm.digest_price
      s.hour_price = pm.hour_price
    end
  end
  
  def total_run_time
    blank_run_time + billable_run_time + loading_time
  end #total_run_time
  
  def loading_time
    samples.to_a.sum(&:unbilled_loading_time)
  end #loading_time
  
  def blank_run_time
    (blank_runs.nil? or blank_gradient.nil?) ? blanks.inject(0){|sum, b| sum += b.runs * b.gradient} :
                                              blank_runs * blank_gradient
  end #blank_run_time
  
  def additional_required?
    return nil if project.nil?
    
    project.additional_required?
  end #additional_required?
  
  def billable_digests
    samples.to_a.sum(&:billable_digests)
  end
  
  def billable_run_time
    samples.to_a.sum(&:billable_time) 
  end
  
  def amount_due
    samples.to_a.sum(&:cost)
  end
  
  def total_runs
    samples.to_a.sum(&:runs)
  end
  
  def total_blank_runs
    blank_runs ||= blanks.to_a.sum(&:runs)
  end
  
  def pi_and_department
    pi.nil? ? "" : "#{pi} / #{department}"
  end
  
  def has_invoice?
    invoice.nil? ? false : true
  end
  
  def to_text
    text = ''
    text += (date_run.nil? ? created_at.to_date.to_s : date_run.to_date.to_s) + "\t"
  	text += [user.email,
  	        project.name,
  	        pi,
  	        department,
  	        purchase_order,
  	        instrument,
  	        total_run_time,
  	        billable_run_time,
  	        billable_digests,
  	        samples.size,
  	        total_runs,
  	        total_blank_runs,
            amount_due,
            unbillable].join("\t")  	
  end
  
  ### self methods ###
  
  def self.user_totals_past_year
    json = Hash.new
    Entry.where("date_run > current_date - interval '1 year'").group(:user_id).count().each do |uid, count|
      json["vars"].nil? ? json["vars"] = [User.find(uid).name] : json["vars"] << User.find(uid).name
      json["data"].nil? ? json["data"] = [[count]] : json["data"] << [count]
    end
    json["smps"] = ["Total Entries"]
    json
  end #self.user_totals
  
  def self.instrument_count
    data = Hash.new
    instrument_rollup.each do |r|
      data[r[0]] ||= 0
      data[r[0]] += 1
    end
    data.to_a
  end #instrument_count
  
  def self.instrument_hours
    json = Hash.new
    instrument_rollup.each do |instrument, entries|
      json["vars"].nil? ? json["vars"] = [instrument] : json["vars"] << instrument
      #sum total run time for each entry with a given instrument
      total = entries.inject(0) { |sum, e| sum + e.total_run_time / 60.0 } 
      json["data"].nil? ? json["data"] = [[total]] : json["data"] << [total]
    end #instrument_rollup.each
    json["smps"] = ["Total Hours"]
    json      
  end #instrument_hours
  
  def self.instrument_hours_two_years
    year1 = instrument_hours_with_condition("date_run > current_date - interval '1 year'")
    year2 = instrument_hours_with_condition("date_run > current_date - interval '2 year' "+ 
                                            "AND date_run < current_date - interval '1 year'") 
    instruments = (year1["vars"] + year2["vars"]).uniq
    json = Hash.new()
    json["vars"] ||= []
    json["data"] ||= []
    
    instruments.each do |instrument|
      json["vars"] << instrument
      data = []
      data[0] = (year1["vars"].index(instrument).nil? ? 0 : year1["data"][year1["vars"].index(instrument)])
      data[1] = (year2["vars"].index(instrument).nil? ? 0 : year2["data"][year2["vars"].index(instrument)])
      json["data"] << data.flatten
    end #instrument.each
    json["smps"] = ["Total Hours Last Year", "Total Hours Year Before Last"]
    json      
  end #instrument_hours_two_years
  
  def self.instrument_hours_with_condition(condition)
    json = Hash.new
    json["vars"] = []
    json["data"] = []
    instrument_rollup(condition).each do |instrument, entries|
      #json["vars"].nil? ? json["vars"] = [instrument] : json["vars"] << instrument
      json["vars"] << instrument
      #sum total run time for each entry with a given instrument
      total = entries.inject(0) { |sum, e| sum + e.total_run_time / 60.0} 
      json["data"].nil? ? json["data"] = [[total]] : json["data"] << [total]
    end
    
    json["smps"] = ["Total Hours"]
    json    
  end #self.instrument_hours_with_condition
  
  def self.instrument_usage_past_year
    usage = self.instrument_usage
    json = Hash.new
    json["vars"] = usage.keys
    json["smps"] = usage.values.collect{|v| v.keys}.flatten.uniq.sort
    json["desc"] = ["Minutes Run"]
    json["data"] = []
    
    json["vars"].each do |i|
      data = []
      json["smps"].each do |d|
        data << usage[i][d]
      end
      json["data"] << data.collect {|x| x.nil? ? 0 : x }
    end #json["vars"]
    
    #transform numeric date back to human readable date object
    json["smps"].collect! {|x| x.to_date}
    
    json
  end #self.instrument_usage_past_year
  
  def self.usage_and_maintenance
    m = MaintenanceEntry.instrument_usage
    m_hash = Hash.new(Hash.new(0))
    m.keys.each  do |a|
      i = Instrument.find(a[0]).name + "_maintenance"
      m_hash[i].empty? and 
        m_hash[i] = {a[1].to_date.to_s(:number) => m[a]} or 
        m_hash[i][a[1].to_date.to_s(:number)] = m[a]
    end #each
    
    usage = self.instrument_usage
        
    json = Hash.new
    json["vars"] = usage.keys
    json["vars"].concat(m_hash.keys.sort)
    
    json["smps"] = usage.values.collect{|v| v.keys}.flatten.uniq.sort
    json["smps"].concat(m_hash.values.collect{|v| v.keys}.flatten.uniq.sort)
    json["smps"].sort!.uniq!
    
    json["data"] = []
    json["vars"].each do |i|
      data = []
      json["smps"].each do |d|
        if(i =~ /_maintenance$/i)
          data << m_hash[i][d] 
        else
          data << usage[i][d]
        end #if-else
      end
      json["data"] << data.collect {|x| x.nil? ? 0 : x }
    end #json["vars"]
    
    #transform numeric date back to human readable date object
    json["smps"].collect! {|x| x.to_date}
    
    return json
  end #self.usage_and_maintenance
  
  def self.instrument_usage
    report = Hash.new
    self.uniq.pluck(:instrument).each do |i|
      dates = Hash.new
      self.select(:date_run).where(:instrument => i).uniq.each do |e|
        dates[e.date_run.to_s(:number)] = self.where(:date_run => e.date_run, :instrument => i).to_a.sum(&:total_run_time)
      end #select
      report[i] = dates
    end
    report
  end #self.instrument_usage

private

  def self.instrument_rollup(condition = nil)
    if condition
      self.where(condition).group_by{ |e| e.instrument}
    else
      self.all.group_by {|e| e.instrument }
    end #if-else
  end
  
  def valid_project?
    errors.add(:id, 'user is not authorized on that project') unless user.lab.projects.include?(project)
  end
  
  def samples_present?
    errors.add(:id, 'must have at least one sample') if samples.empty?
  end
  
  def blanks_present?
    errors.add(:id, 'must have at least one blank') if blanks.empty?
  end
  
end
