require "test_helper"

class GravesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get graves_index_url
    assert_response :success
  end

  test "should get show" do
    get graves_show_url
    assert_response :success
  end
end
