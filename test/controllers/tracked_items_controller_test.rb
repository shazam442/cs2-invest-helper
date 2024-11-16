require "test_helper"

class TrackedItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get tracked_items_show_url
    assert_response :success
  end

  test "should get create" do
    get tracked_items_create_url
    assert_response :success
  end

  test "should get delete" do
    get tracked_items_delete_url
    assert_response :success
  end
end
