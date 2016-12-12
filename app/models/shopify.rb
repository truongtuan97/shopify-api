class Shopify < ApplicationRecord
  validate :request_gift_card, on: :create
end
