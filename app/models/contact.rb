class Contact < ApplicationRecord
  belongs_to :user

  has_many :email_addresses, dependent: :destroy
  has_many :phone_numbers, dependent: :destroy

  validates :first_name, presence: true, length: { minimum: 3, maximum: 255 }
  validates :last_name, length: { minimum: 3, maximum: 255 }

  def self.prepare_for_create(params)
    contact = self.new
    contact.first_name = params[:first_name]
    contact.last_name = params[:last_name]
    contact.birthdate = params[:birthdate]

    if params[:email_addresses].present?
      params[:email_addresses].each do |email_params|
        email_address = EmailAddress.new(email_params)
        email_address.contact = contact
        contact.email_addresses << email_address
      end
    end

    if params[:phone_numbers].present?
      params[:phone_numbers].each do |phone_params|
        phone_number = PhoneNumber.new(phone_params)
        phone_number.contact = contact
        contact.phone_numbers << phone_number
      end
    end

    contact
  end

  def save_with_children
    ActiveRecord::Base.transaction do
      if save!
        email_addresses.each do |email_address|
          email_address.contact = self
          email_address.save!
        end

        phone_numbers.each do |phone_number|
          phone_number.contact = self
          phone_number.save!
        end
      end
    end

    true
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end
end
