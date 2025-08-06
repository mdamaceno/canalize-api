class ContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact, only: [ :show, :update, :destroy ]

  def index
    contacts = current_user.contacts.all

    ok_response(contacts.map { |contact| ContactSerializer.new(contact).as_json })
  end

  def show
    ok_response(ContactSerializer.new(@contact).as_json)
  end

  def create
    contact = current_user.contacts.prepare_for_create(create_contact_params)

    return ok_response(contact, status: :created) if contact.save_with_children

    error_response(contact.errors.full_messages)
  end

  def update
    return ok_response(@contact, status: :ok) if @contact.update(update_contact_params)

    error_response(@contact.errors.full_messages)
  end

  def destroy
    @contact.destroy
    head :no_content
  end

  private

  def set_contact
    @contact = current_user.contacts.find_by(identifier: params[:id])
  end

  def create_contact_params
    params.require(:contact).permit(:first_name, :last_name, :birthdate, email_addresses: [ :email, :label_id ], phone_numbers: [ :country_code, :main, :label_id ])
  end

  def update_contact_params
    params.require(:contact).permit(:first_name, :last_name, :birthdate)
  end
end
