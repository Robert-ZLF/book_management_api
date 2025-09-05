Rails.application.routes.draw do
  # Swagger API Docs
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      # Users
      resources :users, only: [:create, :show]
      # Books
      resources :book_items, only: [:index, :show, :create, :update, :destroy]
      # Borrow/Return
      post '/borrow', to: 'borrow_records#borrow'
      post '/return', to: 'borrow_records#return'
      # User Reports
      get '/users/:user_id/reports/monthly', to: 'user_reports#monthly'
      get '/users/:user_id/reports/yearly', to: 'user_reports#yearly'
      # Income
      get '/book_items/:book_item_id/income', to: 'book_statistics#income'
    end
  end
end