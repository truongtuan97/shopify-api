class AddHmacHeaderToShopifies < ActiveRecord::Migration[5.0]
  def change
    add_column :shopifies, :hmac_header, :string
    add_column :shopifies, :count_hmac_header, :integer
  end
end
