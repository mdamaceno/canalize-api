class EmailAddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact
  before_action :set_email_address, only: [ :update, :destroy ]

  def index
    email_addresses = @contact.email_addresses.all

    ok_response(email_addresses.map { |email_address| EmailAddressSerializer.new(email_address).as_json })
  end

  def create
    email_address = @contact.email_addresses.new(email_address_params)

    return ok_response(EmailAddressSerializer.new(email_address).as_json, status: :created) if email_address.save

    error_response(email_address.errors.full_messages)
  end

  def update
    return ok_response(EmailAddressSerializer.new(@email_address).as_json, status: :ok) if @email_address.update(email_address_params)

    error_response(@email_address.errors.full_messages)
  end

  def destroy
    @email_address.destroy
    head :no_content
  end

  private

  def set_contact
    @contact = current_user.contacts.find_by(identifier: params[:contact_id])
  end

  def set_email_address
    @email_address = @contact.email_addresses.find_by(identifier: params[:id])
  end

  def email_address_params
    params.require(:email_address).permit(:email, :label_id)
  end
end
