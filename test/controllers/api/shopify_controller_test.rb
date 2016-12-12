require 'test_helper'

class Api::ShopifyControllerTest < ActionDispatch::IntegrationTest
  test "should get request-gift-card" do
    get api_shopify_request-gift-card_url
    assert_response :success
  end

end
