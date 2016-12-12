class CreateGiftCardUseds < ActiveRecord::Migration[5.0]
  def change
    create_table :gift_card_useds do |t|
      t.string :gift_card_code
      t.string :email
      t.datetime :time_send_email

      t.timestamps
    end
  end
end
