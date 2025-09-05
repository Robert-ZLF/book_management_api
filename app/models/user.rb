class User < ApplicationRecord
  validates :balance, numericality: { greater_than_or_equal_to: 0 }
  validates :name, presence: true

  has_many :borrow_records, dependent: :destroy
  has_many :current_book_items, -> { where(borrow_records: { returned: false }) }, through: :borrow_records, source: :book_item
end