module Api
  module V1
    class BookStatisticsController < ApplicationController
      def income
        book_item = BookItem.find_by(id: params[:book_item_id])
        start_date = params[:start_date] ? Date.parse(params[:start_date]) : nil
        end_date = params[:end_date] ? Date.parse(params[:end_date]) : nil

        return render json: { error: "BookItem not found" }, status: :not_found unless book_item
        return render json: { error: "Start date and end date are required (format: YYYY-MM-DD)" }, status: :bad_request unless start_date && end_date
        return render json: { error: "Start date cannot be later than end date" }, status: :bad_request if start_date > end_date

        income_records = book_item.borrow_records.where(
          returned: true,
          return_date: start_date.beginning_of_day..end_date.end_of_day
        )
        total_income = income_records.sum(:fee)

        render json: {
          book_item_id: book_item.id,
          book_title: book_item.title,
          statistics_period: {
            start_date: start_date.strftime("%Y-%m-%d"),
            end_date: end_date.strftime("%Y-%m-%d")
          },
          total_income: total_income,
          record_count: income_records.count
        }, status: :ok
      end
    end
  end
end