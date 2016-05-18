require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test 'create should require user to login' do
    assert_no_difference 'Relationship.count' do
      post :create
    end
    assert_redirected_to login_url
  end
  
  test 'destroy should require login' do
    assert_no_difference 'Relationship.count' do
      delete :destroy, id: relationships(:one)
    end
    assert_redirected_to login_url
  end  
end
