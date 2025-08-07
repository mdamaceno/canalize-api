class EmailAddressSerializer
  attr_reader :email_address

  def initialize(email_address)
    @email_address = email_address
  end

  def as_json
    {
      identifier: email_address.identifier,
      email: email_address.email,
      label: label
    }
  end

  private

  def label
    email_address.label ? { id: email_address.label.identifier, name: email_address.label.name } : nil
  end
end
