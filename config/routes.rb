Rails.application.routes.draw do
  resources :gift_card_useds
  resources :gift_cards
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    match 'shopify/request-gift-card' => 'Shopify/request_gift_card', via: [:options, :post]
  end
end
