class ContactSerializer
  attr_reader :contact

  def initialize(contact)
    @contact = contact
  end

  def as_json
    {
      identifier: contact.identifier,
      first_name: contact.first_name,
      last_name: contact.last_name,
      birthdate: contact.birthdate,
      email_addresses: email_addresses,
      phone_numbers: phone_numbers
    }
  end

  private

  def email_addresses
    contact.email_addresses.map do |email|
      {
        identifier: email.identifier,
        email: email.email
      }
    end
  end

  def phone_numbers
    contact.phone_numbers.map do |phone|
      {
        identifier: phone.identifier,
        country_code: phone.country_code,
        main: phone.main
      }
    end
  end
end
