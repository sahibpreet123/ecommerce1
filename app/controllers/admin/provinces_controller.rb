
class Admin::ProvincesController < ApplicationController
    before_action :set_province, only: [:edit, :update]
    before_action :authenticate_admin!
  
    def index
      @provinces = Province.all
    end
  
    def edit
      # Set_province before_action will set @province for the view
    end
  
    def update
      if @province.update(province_params)
        redirect_to admin_provinces_path, notice: 'Tax rates were successfully updated.'
      else
        render :edit
      end
    end
  
    private
  
    def set_province
      @province = Province.find(params[:id])
    end
  
    def province_params
      params.require(:province).permit(:gst, :pst, :hst)
    end
  end
  