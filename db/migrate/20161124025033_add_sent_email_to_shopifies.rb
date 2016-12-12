class AddSentEmailToShopifies < ActiveRecord::Migration[5.0]
  def change
    add_column :shopifies, :sent_email, :boolean
  end
end
