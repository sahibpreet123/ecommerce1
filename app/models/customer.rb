class Customer < ApplicationRecord
  belongs_to :user
  has_many :orders
  belongs_to :province
  validates :name, presence: true
end

