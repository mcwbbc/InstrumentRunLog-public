class InvoicesController < ApplicationController
  before_filter :authenticate
  before_filter :admin
    
  def index
    @invoices = Invoice.all
  end
  
  def new
    @invoice = Invoice.new
    @entries = Entry.find_ready_for_invoice
  end
  
  def show
    @invoice = Invoice.find(params[:id])
    
    respond_to do |format|
      format.html
      format.text {render :text => @invoice.to_text}
    end
  end
  
  def create
    @invoice = Invoice.new(params[:invoice])
    if params[:include].nil?
      @invoice.save
      flash[:notice] = 'No Invoice Selected'
      redirect_to new_invoice_path
    else
      params[:include].each {|i| @invoice.entries << Entry.find(i)}
    
      if @invoice.save
        redirect_to invoice_path(@invoice), :notice => "Invoice Created"
      else
        redirect_to new_invoice_path, :notice => "Invoice Failed"
      end #if-else
      
    end #if-else
  end #create
end
