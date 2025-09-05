module Api
  module V1
    class UsersController < ApplicationController
      def create
        user = User.new(user_params)
        if user.save
          render json: { user_id: user.id, name: user.name, balance: user.balance }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        user = User.find_by(id: params[:id])
        if user
          render json: {
            user_id: user.id,
            name: user.name,
            balance: user.balance,
            current_books: user.current_book_items.map { |book| { book_id: book.id, title: book.title } }
          }, status: :ok
        else
          render json: { error: "User not found" }, status: :not_found
        end
      end

      private
      def user_params
        params.require(:user).permit(:name, :balance)
      end
    end
  end
end