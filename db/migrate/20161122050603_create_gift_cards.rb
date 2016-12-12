class CreateGiftCards < ActiveRecord::Migration[5.0]
  def change
    create_table :gift_cards do |t|
      t.string :gift_card_code
      t.integer :price

      t.timestamps
    end
  end
end
