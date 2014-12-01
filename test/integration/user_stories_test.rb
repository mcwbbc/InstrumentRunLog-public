require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :all

  # Replace this with your real tests.
  test "should login create entry and logout" do
    dummy = registered_user
    dummy.logs_in 'dummy@test.edu', 'secret'
    
    samples = [{:digests => 2, :gradient => 60, :runs => 2, :price_model_id => price_models(:one).id}]
    entry = {:blank_runs => 1, :blank_gradient => 60, :samples_attributes => samples, :project_id => projects(:testProject).id}
    dummy.creates_entry entry
    
    dummy.logs_out
  end #test
  
  test "admin should create invoice" 
  
  private
  
  def registered_user
    open_session do |user|
      def user.logs_in(email, password)
        get login_path
        
        assert_response :success
        assert_template 'new'
        
        post session_path, :email => email, :password => password
        
        assert_response :redirect
        assert_redirected_to root_path
        
        follow_redirect!
        
        assert_response :success
        assert_template 'index'
        assert session[:user_id]
      end #user.logs_in
      
      def user.logs_out
        get logout_path
        
        assert_response :redirect
        assert_redirected_to root_path
        assert_nil session[:user_id]
        
        follow_redirect!
        
        assert_template 'index'
      end #user.logs_out
      
      def user.creates_entry(entry_hash)
        get new_entry_path
        
        assert_response :success
        assert_template 'new'
        
        post entries_path, :entry => entry_hash
        
        assert assigns(:entry).valid?
        assert_response :redirect
        assert_redirected_to entry_path(assigns(:entry))
        
        follow_redirect!
        
        assert_response :success
        assert_template 'show'
      end #user.creates_entry
      
      def user.creates_invoice(invoice_hash)
        get new_invoice_path
        
        assert_response :success
        assert_template 'new'
        
        post invoices_path, :invoice => invoice_hash
        
        assert assigns(:invoice).valid?
        assert_response :redirect
        assert_redirected_to invoice_path(assigns(:invoice))
        
        follow_redirect!
        
        assert_response :success
        assert_template 'show'
      end #user.creates_invoice
      
    end#open_session
  end#registered_user
  
end
