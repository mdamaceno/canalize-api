class PhoneNumbersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact
  before_action :set_phone_number, only: [ :update, :destroy ]

  def index
    phone_numbers = @contact.phone_numbers.all

    ok_response(phone_numbers.map { |phone_number| PhoneNumberSerializer.new(phone_number).as_json })
  end

  def create
    phone_number = @contact.phone_numbers.new(phone_number_params)

    return ok_response(PhoneNumberSerializer.new(phone_number).as_json, status: :created) if phone_number.save

    error_response(phone_number.errors.full_messages)
  end

  def update
    return ok_response(PhoneNumberSerializer.new(@phone_number).as_json, status: :ok) if @phone_number.update(phone_number_params)

    error_response(@phone_number.errors.full_messages)
  end

  def destroy
    @phone_number.destroy
    head :no_content
  end

  private

  def set_contact
    @contact = current_user.contacts.find_by(identifier: params[:contact_id])
  end

  def set_phone_number
    @phone_number = @contact.phone_numbers.find_by(identifier: params[:id])
  end

  def phone_number_params
    params.require(:phone_number).permit(:main, :country_code, :label_id)
  end
end
