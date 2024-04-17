class Admin::ProductsController < ApplicationController
    before_action :authenticate_admin!
  
    def index
      @products = Product.all
    end
  
    def new
      @product = Product.new
    end
    
  
    
    def show
      @product = Product.find_by(id: params[:id])
      if @product.nil?
        redirect_to admin_products_path, alert: 'Product not found.'
      end
    end

    def create
      @product = Product.new(product_params)
      if @product.save
        redirect_to admin_products_path, notice: 'Product was successfully created.'
      else
        render :new
      end
    end
        
  
    def edit
      @product = Product.find(params[:id])
    end
  
    def update
      @product = Product.find(params[:id])

      if @product.update(product_params)
        redirect_to admin_products_path, notice: 'Product was successfully updated.'
      else
        render :edit
      end
    end
  
  
    def destroy
      @product = Product.find(params[:id])
      @product.destroy
      redirect_to admin_products_path, notice: 'Product was successfully destroyed.'
    end
  
    private
  
    def product_params
      params.require(:product).permit(:name, :description, :price, :ingredients, :image, :category_id, :on_sale)
    end    
end
  