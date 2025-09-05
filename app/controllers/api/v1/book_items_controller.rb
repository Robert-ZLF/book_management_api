module Api
  module V1
    class BookItemsController < ApplicationController

      def index
        book_items = BookItem.all
        render json: book_items.map { |book| book_details(book) }, status: :ok
      end

      def show
        book_item = BookItem.find_by(id: params[:id])
        if book_item
          render json: book_details(book_item), status: :ok
        else
          render json: { error: "BookItem not found" }, status: :not_found
        end
      end

      def create
        book_item = BookItem.new(book_item_params)
        if book_item.save
          render json: book_details(book_item), status: :created
        else
          render json: { errors: book_item.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        book_item = BookItem.find_by(id: params[:id])
        if book_item && book_item.update(book_item_params)
          render json: book_details(book_item), status: :ok
        elsif !book_item
          render json: { error: "BookItem not found" }, status: :not_found
        else
          render json: { errors: book_item.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        book_item = BookItem.find_by(id: params[:id])
        if book_item
          book_item.destroy
          render json: { message: "BookItem deleted successfully" }, status: :ok
        else
          render json: { error: "BookItem not found" }, status: :not_found
        end
      end

      private
      def book_details(book)
        {
          book_id: book.id,
          title: book.title,
          stock_quantity: book.stock_quantity,
          borrow_count: book.borrow_count,
          current_borrowers: book.current_borrowers.map { |user| { user_id: user.id, name: user.name } }
        }
      end

      def book_item_params
        params.require(:book_item).permit(:title, :stock_quantity, :borrow_count)
      end
    end
  end
end