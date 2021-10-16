class OrdersController < ApplicationController

  def show

    if params[:id]
      @order = Order.find(params[:id])
      @line_items = Order.find(params[:id]).line_items  
      # @products =  LineItem.find(params[:id]).products    
      # @products = Product.joins(:line_items).where(>>>>>LINE_ITEMS.ID<<<<<)
      # @products = Order.find(params[:id]).line_items.product
      # @products = LineItem.find(params[:id]).product
      # @products = Product.joins(:line_items).where(line_items.order_id: @order.id)
    end

    # *********TODO Using joins method is failed. These make join queries but can't add prod fields into LineItem Obj
    # *********TODO Try it again later...
    # @order_items = Product.joins(:line_items).where(order_id: @order.id)
    # @order_items = LineItem.joins(:product).includes(:product).where(order_id: @order.id)
    # @products = LineItem.joins(:product).select("products.*, line_items.*").where(order_id: @order.id)
    # @order_items = LineItem.select("line_items.*, products.image").joins(:product).where(order_id: @order.id)
    # @order_items = LineItem.select("line_items.*, products.image").find(order_id: @order.id).product

  end

  def create
    charge = perform_stripe_charge
    order  = create_order(charge)

    if order.valid?
      empty_cart!
      redirect_to order, notice: 'Your Order has been placed.'
    else
      redirect_to cart_path, flash: { error: order.errors.full_messages.first }
    end

  rescue Stripe::CardError => e
    redirect_to cart_path, flash: { error: e.message }
  end

  private

  def empty_cart!
    # empty hash means no products in cart :)
    update_cart({})
  end

  def perform_stripe_charge
    Stripe::Charge.create(
      source:      params[:stripeToken],
      amount:      cart_subtotal_cents,
      description: "Khurram Virani's Jungle Order",
      currency:    'cad'
    )
  end

  def create_order(stripe_charge)
    order = Order.new(
      email: params[:stripeEmail],
      total_cents: cart_subtotal_cents,
      stripe_charge_id: stripe_charge.id, # returned by stripe
    )

    enhanced_cart.each do |entry|
      product = entry[:product]
      quantity = entry[:quantity]
      order.line_items.new(
        product: product,
        quantity: quantity,
        item_price: product.price,
        total_price: product.price * quantity
      )
    end
    order.save!
    order
  end

end
