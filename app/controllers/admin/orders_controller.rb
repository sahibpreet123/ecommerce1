class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_order, only: [:edit, :update, :destroy]

  def index
    @orders =  Order.includes(:customer, :order_items).order(created_at: :desc)
  end

  def edit
  end

  
  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      flash[:notice] = "Order status updated successfully."
    else
      flash[:alert] = "Could not update the order."
    end
    redirect_to admin_orders_path 
  end

  def destroy
    @order.destroy
    redirect_to admin_orders_path, notice: 'Order was successfully destroyed.'
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status)
  end
end
