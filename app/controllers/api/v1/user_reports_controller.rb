module Api
  module V1
    class UserReportsController < ApplicationController
      def monthly
        user = User.find_by(id: params[:user_id])
        year = params[:year].present? ? params[:year].to_i : nil
        month = params[:month].present? ? params[:month].to_i : nil


        return render json: { error: "Year and month are required" }, status: :bad_request unless year.present? && month.present?
        return render json: { error: "Invalid year or month" }, status: :bad_request unless Date.valid_date?(year, month, 1)
        return render json: { error: "User not found" }, status: :not_found unless user

        start_date = Date.new(year, month, 1)
        end_date = start_date.end_of_month
        records = user.borrow_records.where(
          returned: true,
          return_date: start_date..end_date
        )


        total_books = records.count
        total_spent = records.sum(:fee)

        render json: {
          user_id: user.id,
          report_type: "monthly",
          year: year,
          month: month,
          total_books_borrowed: total_books,
          total_spent: total_spent
        }, status: :ok
      end

      def yearly
        user = User.find_by(id: params[:user_id])
        year = params[:year].present? ? params[:year].to_i : nil

        return render json: { error: "User not found" }, status: :not_found unless user
        return render json: { error: "Year is required" }, status: :bad_request unless year.present?

        start_date = Date.new(year, 1, 1)
        end_date = start_date.end_of_year
        records = user.borrow_records.where(
          returned: true,
          return_date: start_date..end_date
        )
        total_books = records.count
        total_spent = records.sum(:fee)

        render json: {
          user_id: user.id,
          report_type: "yearly",
          year: year,
          total_books_borrowed: total_books,
          total_spent: total_spent
        }, status: :ok
      end
    end
  end
end