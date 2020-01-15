class OrdersController < ApplicationController

  def new
    if !session[:user_id]
      flash[:notice] = 'Please register or login before trying to checkout'
      redirect_to '/cart'
    end
  end

  def show
    if current_user && current_user.default?
      @order = Order.find(params[:id])
    else
      render 'errors/404'
    end
  end

  def create
    if session[:coupon] 
      applied_coupon = Coupon.find(session[:coupon].first["id"])
    end
     
    order = Order.create(order_params)
    order.coupon = applied_coupon
    
    current_user.orders << order
    if order.save
      cart.items.each do |item,quantity|
        if applied_coupon && (item.merchant_id == order.coupon.merchant.id) 
          order.item_orders.create({
            item: item,
            quantity: quantity,
            price: (item.price * ( (100 - order.coupon.percentage_off) / 100)) 
            })
        else
          order.item_orders.create({
            item: item,
            quantity: quantity,
            price: item.price 
            })
        end
      end
      session.delete(:cart)
      session.delete(:coupon)
      flash[:success] = 'Order created successfully'
      redirect_to "/profile/orders"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def index
    if current_user && current_user.default?
      @orders = current_user.orders
    else
      render 'errors/404'
    end
  end

  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end

end
