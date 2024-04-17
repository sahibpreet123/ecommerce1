class Province < ApplicationRecord
  has_many :customers
  has_many :orders
  

  validates :name, presence: true, uniqueness: { scope: :category_id }

  validates :price, numericality: { greater_than: 0 }

  validates :description, presence: true, length: { maximum: 500 }
end
