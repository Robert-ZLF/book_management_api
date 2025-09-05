class BookItem < ApplicationRecord
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :borrow_count, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :title, presence: true

  has_many :borrow_records, dependent: :destroy
  has_many :current_borrowers, -> { where(borrow_records: { returned: false }) }, through: :borrow_records, source: :user
  after_initialize :set_default_borrow_count, if: :new_record?
  def set_default_borrow_count
    self.borrow_count ||= 0
  end
end