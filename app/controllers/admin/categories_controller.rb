class Admin::CategoriesController < ApplicationController
  http_basic_authenticate_with name: ENV['ADMIN_NAME'], password: ENV['ADMIN_PASSWORD']

  def index
    @product_count_category = Product.group(:category).count 
  end

  def create
  end

  def new
    @category = Category.new    
  end
end
