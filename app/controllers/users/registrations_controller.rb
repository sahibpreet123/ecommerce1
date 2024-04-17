# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_provinces, only: [:new] 

  def new
    super do |user|
      user.build_customer
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, customer_attributes: [:name, :address, :province_id]])
  end

  private

  def set_provinces
    @provinces = Province.all.collect { |p| [p.name, p.id] }
  end
end
