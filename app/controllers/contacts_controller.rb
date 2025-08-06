class ContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact, only: [:show, :update, :destroy]

  def index
    @contacts = current_user.contacts.all
  end

  def show
  end

  def create
    @contact = current_user.contacts.prepare_for_create(create_contact_params)

    return ok_response(@contact, status: :created) if @contact.save_with_children

    error_response(@contact.errors.full_messages)
  end

  def update
    if @contact.update(update_contact_params)
      redirect_to @contact, notice: 'Contact was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @contact.destroy
    redirect_to contacts_url, notice: 'Contact was successfully destroyed.'
  end

  private

  def set_contact
    @contact = current_user.contacts.find_by(identifier: params[:id])
  end

  def create_contact_params
    params.require(:contact).permit(:first_name, :last_name, :birthdate, email_addresses: [:email, :label_id], phone_numbers: [:country_code, :main, :label_id])
  end

  def update_contact_params
    params.require(:contact).permit(:first_name, :last_name, :birthdate)
  end
end
