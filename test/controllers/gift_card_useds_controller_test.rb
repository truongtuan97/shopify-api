require 'test_helper'

class GiftCardUsedsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gift_card_used = gift_card_useds(:one)
  end

  test "should get index" do
    get gift_card_useds_url, as: :json
    assert_response :success
  end

  test "should create gift_card_used" do
    assert_difference('GiftCardUsed.count') do
      post gift_card_useds_url, params: { gift_card_used: { Email: @gift_card_used.Email, GiftCardCode: @gift_card_used.GiftCardCode, TimeSendEmail: @gift_card_used.TimeSendEmail } }, as: :json
    end

    assert_response 201
  end

  test "should show gift_card_used" do
    get gift_card_used_url(@gift_card_used), as: :json
    assert_response :success
  end

  test "should update gift_card_used" do
    patch gift_card_used_url(@gift_card_used), params: { gift_card_used: { Email: @gift_card_used.Email, GiftCardCode: @gift_card_used.GiftCardCode, TimeSendEmail: @gift_card_used.TimeSendEmail } }, as: :json
    assert_response 200
  end

  test "should destroy gift_card_used" do
    assert_difference('GiftCardUsed.count', -1) do
      delete gift_card_used_url(@gift_card_used), as: :json
    end

    assert_response 204
  end
end
