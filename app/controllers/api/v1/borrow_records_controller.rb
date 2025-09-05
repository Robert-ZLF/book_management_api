module Api
  module V1
    class BorrowRecordsController < ApplicationController

      def borrow
        user = User.find_by(id: params[:user_id])
        book_item = BookItem.find_by(id: params[:book_item_id])
        fee = params[:fee].to_d

        return render json: { error: "User not found" }, status: :not_found unless user
        return render json: { error: "BookItem not found" }, status: :not_found unless book_item
        return render json: { error: "No available copies of the book" }, status: :bad_request if book_item.stock_quantity <= 0
        return render json: { error: "User has no cash (balance is zero)" }, status: :bad_request if user.balance <= 0

        existing_record = BorrowRecord.find_by(user: user, book_item: book_item, returned: false)
        return render json: { error: "User already borrowed this book" }, status: :bad_request if existing_record

        # Use transaction to ensure atomicity
        ActiveRecord::Base.transaction do
          # 1. Decrement book stock quantity
          book_item.decrement!(:stock_quantity)
          # 2. Increment book borrow count
          book_item.increment!(:borrow_count)
          # 3. Create borrow record
          BorrowRecord.create!(
            user: user,
            book_item: book_item,
            fee: fee
          )
        end

        render json: {
          message: "Book borrowed successfully",
          user_id: user.id,
          book_item_id: book_item.id,
          remaining_balance: user.balance,
          borrow_fee: fee
        }, status: :ok
      end


      def return
        user = User.find_by(id: params[:user_id])
        book_item = BookItem.find_by(id: params[:book_item_id])

        # check user and book item
        return render json: { error: "User not found" }, status: :not_found unless user
        return render json: { error: "BookItem not found" }, status: :not_found unless book_item

        # check borrow record
        borrow_record = BorrowRecord.find_by(user: user, book_item: book_item, returned: false)
        return render json: { error: "No active borrow record for this user and book" }, status: :bad_request unless borrow_record

        # validate user balance
        required_fee = borrow_record.fee
        return render json: { error: "Insufficient balance to pay the fee" }, status: :bad_request if user.balance < required_fee

        # Use transaction to ensure atomicity
        ActiveRecord::Base.transaction do
          # 1. Decrement user balance
          user.decrement!(:balance, required_fee)
          # 2. Increment book stock quantity
          book_item.increment!(:stock_quantity)
          # 3. Update borrow record (mark as returned, record return time)
          borrow_record.update!(
            returned: true,
            return_date: Time.current
          )
        end

        render json: {
          message: "Book returned successfully",
          user_id: user.id,
          book_item_id: book_item.id,
          fee_paid: required_fee,
          remaining_balance: user.balance
        }, status: :ok
      end
    end
  end
end