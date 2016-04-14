require 'test_helper'

class UsersEditFormTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = users(:athens)
  end
  
  test 'test unsuccessful' do
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: {name: "", email: "invalid", password: "foo", password_confirmation: "bar"}
    assert_template 'users/edit'
  end
  
  test 'successful edit' do
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "Athens test"
    email = "test@test.com"
    patch user_path(@user), user: {name: name, email: email, password: "", password_confirmation: ""}
    assert_not flash.empty?
    assert_redirected_to user_path(@user)
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
    
  end
  
  
  
end
