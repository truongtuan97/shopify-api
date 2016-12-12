class AddPriceToClients < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :price, :integer
  end
end
