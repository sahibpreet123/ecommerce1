class AddAddressToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :address, :string
    add_column :orders, :city, :string
    add_column :orders, :province, :string
    add_column :orders, :postal_code, :string
  end
end
