class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  def ok_response(data, status: :ok)
    render json: { sucess: true, data: data }, status: status
  end

  def error_response(errors, status: :unprocessable_entity)
    render json: { success: false, errors: errors }, status: status
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name])
  end
end
