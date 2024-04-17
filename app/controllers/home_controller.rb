class HomeController < ApplicationController
  before_action :initialize_cart, only: [:add_to_cart, :update_cart_item]

  def index
    @products = Product.all
    if params[:search].present?
      @products = @products.where('name LIKE :search OR description LIKE :search', search: "%#{params[:search]}%")
    end
    
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end
    
    @products = @products.page(params[:page]).per(6) 
    @products = @products.where('created_at >= ?', 3.days.ago) if params[:new_products]
  end

  def new_products
    @new_products = Product.where('created_at >= ?', 3.days.ago)
    @new_products = @new_products.page(params[:page]).per(6)
  end
  
  def show
    @product = Product.find(params[:id])
  end

  def on_sale
    @products_on_sale = Product.where(on_sale: true).page(params[:page]).per(6)
  end

  

  def add_to_cart
    product_id = params[:id].to_i
    quantity = params[:quantity].to_i || 1
  
   
    session[:cart] = [] unless session[:cart].is_a?(Array)
  
    item = session[:cart].find { |i| i["product_id"] == product_id }
  
    if item

      item["quantity"] += quantity
    else
      # Otherwise, add a new item to the cart
      session[:cart] << { "product_id" => product_id, "quantity" => quantity }
    end
  

    redirect_to cart_path, notice: "Product added to cart!"
  end
  

  def update_cart_item
    product_id = params[:id].to_i
    new_quantity = params[:quantity].to_i
  
    item = session[:cart].find { |i| i["product_id"] == product_id }
    if item
      item["quantity"] = new_quantity
      flash[:notice] = "Quantity updated."
    end
  
    redirect_to cart_path
  end

  
  
  def remove_from_cart
    product_id = params[:id].to_i

    session[:cart].delete_if { |item| item["product_id"] == product_id }

    redirect_to cart_path, notice: 'Item removed from cart.'
  end
  
  private

  def initialize_cart
    session[:cart] ||= []
  end

end
