class ChangeColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :gift_cards, :is_used, :used
  end
end
