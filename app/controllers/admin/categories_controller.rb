class Admin::CategoriesController < ApplicationController
  http_basic_authenticate_with name: ENV['ADMIN_NAME'], password: ENV['ADMIN_PASSWORD']

  def index
    ########### TODO #####################################
    ## HOW TO USE LEFT_OUTER_JOIN IN ACTIVERECORD? #######
    ## CAN'T SEE A CATEGORY WHICH DOESN'T HAVE A PRODUCT #

    ## CASE 1
    # @product_count_category = Product.group(:category).count 
    
    ## OR CHANGE TO USE JUST 
    ## CASE 2
    @categories = Category.all
    ## AND remove count on the view

    #Select a.name, IFNULL(b.cnt, 0) as cnt from category a left join (select count(*) as cnt, category_id from product group by category_id) b on a.id = b.category_id;


  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to [:admin, :categories], notice: 'Category created!'
    else
      render :new
    end    
  end

  def new
    @category = Category.new    
  end


  private

  def category_params
    params.require(:category).permit(
      :name
    )
  end  
end
