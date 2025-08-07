class PhoneNumberSerializer
  attr_reader :phone_number

  def initialize(phone_number)
    @phone_number = phone_number
  end

  def as_json
    {
      identifier: phone_number.identifier,
      country_code: "+#{phone_number.country_code}",
      main: phone_number.main,
      label: label
    }
  end

  private

  def label
    phone_number.label ? { id: phone_number.label.identifier, name: phone_number.label.name } : nil
  end
end
