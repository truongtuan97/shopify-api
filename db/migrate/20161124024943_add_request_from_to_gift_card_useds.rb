class AddRequestFromToGiftCardUseds < ActiveRecord::Migration[5.0]
  def change
    add_column :gift_card_useds, :request_from, :string
  end
end
