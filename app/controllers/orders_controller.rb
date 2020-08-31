class OrdersController < ApplicationController
  skip_before_action :authorized, only: [:create]


  def create
    @user = User.find_by(id: params[:user_id])
    cart_id = @user.cart.id
    @order = Order.find_by(cart_id: cart_id, product_id: params[:product_id])
    quantity = params[:quantity]
    if @order
      if (!quantity)
        quantity = @order.quantity
        @order.update(quantity: quantity + 1)
        render json: @order
      elsif (quantity)
        if quantity == 0
          @order.destroy
          render json: {message: 'order removed'}
        else
          @order.update(quantity: params[:quantity])
        end
        render json: @order
      end
    else
      @order = Order.new(cart_id: cart_id, product_id: params[:product_id], quantity: 1)
      if (@order.save)
        render json: @order
      else
        render json: {error: 'Failed to save'}
      end
    end
  end
end
