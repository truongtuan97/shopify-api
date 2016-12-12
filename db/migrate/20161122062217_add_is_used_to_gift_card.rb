class AddIsUsedToGiftCard < ActiveRecord::Migration[5.0]
  def change
    add_column :gift_cards, :is_used, :boolean, default: false
  end
end
