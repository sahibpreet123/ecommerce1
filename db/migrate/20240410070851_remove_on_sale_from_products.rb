class RemoveOnSaleFromProducts < ActiveRecord::Migration[7.1]
  def change
    remove_column :products, :on_sale, :boolean
  end
end
