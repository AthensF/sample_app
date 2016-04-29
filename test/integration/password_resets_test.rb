require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:athens)
  end
  
  test 'password resets' do
    get new_password_reset_path
    assert_template 'password_resets/new'
    
    #invalid email
    post password_resets_path, password_reset: {email: ''}
    assert_not flash.empty?
    assert_template 'password_resets/new'
    
    #valid email
    post password_resets_path, password_reset: {email: @user.email}
    # trigger change in reset digest
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    
    #send out mailer
    assert_equal 1, ActionMailer::Base.deliveries.size
    
    #new page
    assert_not flash.empty?
    assert_redirected_to root_path
    
    #password reset form
    user = assigns(:user)
    
    #wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_path
    
    #right email, wrong token
    get edit_password_reset_path("", email: user.email)
    assert_redirected_to root_path
    
    #inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_path
    user.toggle!(:activated)
    
    #right email and right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email #find email in html body
    
    #invalid password and confirmation
    patch password_reset_path(user.reset_token), 
      email: user.email,
      user: {password: 'foobaz',
        password_confirmation: 'barquea'
      }
    assert_select 'div#error_explanation'
    
    #empty password
    patch password_reset_path(user.reset_token), 
      email: user.email,
      user: {password: '',
        password_confirmation: ''
      }
    assert_select 'div#error_explanation'    
    
    # valid password and confirmation
    patch password_reset_path(user.reset_token), 
      email: user.email,
      user: {password: 'foobar',
        password_confirmation: 'foobar'
      }
    assert_not flash.empty?  
    assert_redirected_to user
    assert is_logged_in?
  end
end
