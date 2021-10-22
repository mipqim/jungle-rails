class Admin::DashboardController < ApplicationController
  http_basic_authenticate_with name: ENV['ADMIN_NAME'], password: ENV['ADMIN_PASSWORD']

  puts Product.count
  def show
    @product_count = Product.count
    @category_count = Category.count

    #select count(*) from products group by category_id / return [category, count]
    #@product_count_category = Product.group(:category).count 
    @categories = Category.all
  end
end
