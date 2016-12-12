class CreateShopifies < ActiveRecord::Migration[5.0]
  def change
    create_table :shopifies do |t|
      t.string :request_gift_card

      t.timestamps
    end
  end
end
