class Admin::DashboardController < ApplicationController
  http_basic_authenticate_with name: ENV['ADMIN_NAME'], password: ENV['ADMIN_PASSWORD']

#   Display a count of how many products are in the database
# Display a count of how many categories are in the database

  puts Product.count
  def show
    @product_count = Product.count
    @category_count = Category.count
  end
end
