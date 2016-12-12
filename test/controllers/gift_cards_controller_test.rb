require 'test_helper'

class GiftCardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gift_card = gift_cards(:one)
  end

  test "should get index" do
    get gift_cards_url, as: :json
    assert_response :success
  end

  test "should create gift_card" do
    assert_difference('GiftCard.count') do
      post gift_cards_url, params: { gift_card: { GiftCardCode: @gift_card.GiftCardCode, Price: @gift_card.Price } }, as: :json
    end

    assert_response 201
  end

  test "should show gift_card" do
    get gift_card_url(@gift_card), as: :json
    assert_response :success
  end

  test "should update gift_card" do
    patch gift_card_url(@gift_card), params: { gift_card: { GiftCardCode: @gift_card.GiftCardCode, Price: @gift_card.Price } }, as: :json
    assert_response 200
  end

  test "should destroy gift_card" do
    assert_difference('GiftCard.count', -1) do
      delete gift_card_url(@gift_card), as: :json
    end

    assert_response 204
  end
end
