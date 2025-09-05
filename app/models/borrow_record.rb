class BorrowRecord < ApplicationRecord
  belongs_to :user
  belongs_to :book_item
  validates :fee, numericality: { greater_than_or_equal_to: 0 }, allow_nil: false
  validates :returned, inclusion: { in: [true, false] }
  validates :return_date, presence: true, if: :returned?
  attribute :borrow_date, :datetime, default: -> { Time.current }
end
