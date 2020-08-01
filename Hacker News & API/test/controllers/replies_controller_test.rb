require 'test_helper'

class RepliesControllerTest < ActionDispatch::IntegrationTest
  test "should get replies" do
    get replies_replies_url
    assert_response :success
  end

end
