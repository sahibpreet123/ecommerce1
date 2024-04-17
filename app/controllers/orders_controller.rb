class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @orders = current_user.customer.orders.order(created_at: :desc)
  end

  def new
    @order = Order.new
    @customer = current_user.customer || current_user.build_customer
    @provinces = Province.all.map { |province| [province.name, province.id] }
    if @customer.address.present?
      @order.address = @customer.address
      @order.province = @customer.province
    end
    
    cart.each do |item|
      @order.order_items.build(product: item[:product], quantity: item[:quantity], price: item[:product].price)
    end
  end
  
  def create
    @customer = current_user.customer || current_user.build_customer
    customer_update_params = {
      address: order_params[:address],
      province_id: order_params[:province_id]
    }
    @customer.assign_attributes(customer_update_params)

    @order = @customer.orders.build(order_params)
    cart.each do |item|
      @order.order_items.build(product: item[:product], quantity: item[:quantity], price: item[:product].price)
    end
  
  
    if @customer.save && @order.save
      begin
        # Setup payment intent with the calculated total
        payment_intent = Stripe::PaymentIntent.create(
          amount: (@order.calculate_total * 100).to_i, # Ensure the amount is in cents
          currency: 'cad',
          description: 'Product Payment',
          payment_method_types: ['card']
        )
        # Save payment intent details and clear the session cart
        @order.update(payment_intent_id: payment_intent.id)
        @order.update(payment_status: :paid)
        session[:cart].clear

        # Redirect to a frontend page where the client can confirm the payment
        redirect_to confirm_payment_order_path(@order, payment_intent: payment_intent.client_secret)
      rescue Stripe::StripeError => e
        flash[:error] = e.message
        render :new, status: :unprocessable_entity
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def confirm_payment
    @order = Order.find(params[:id])
    @client_secret = params[:payment_intent]
  end

  private

  def order_params
    params.require(:order).permit(:subtotal, :gst, :pst, :hst, :total, :address, :province_id, order_items_attributes: [:product_id, :quantity, :price])
  end  

  def customer_params
    params.require(:customer).permit(:name, :email, :address, :province_id)
  end    
end
