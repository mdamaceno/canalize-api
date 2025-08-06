require "test_helper"

class ContactTest < ActiveSupport::TestCase
  test ".save_with_children saves the contact and its associated email addresses and phone numbers" do
    user = users(:one)
    contact = user.contacts.new(first_name: "John", last_name: "Doe")
    email1 = EmailAddress.new(email: Faker::Internet.email)
    email2 = EmailAddress.new(email: Faker::Internet.email)
    phone1 = PhoneNumber.new(country_code: "+1", main: "1234567890")
    phone2 = PhoneNumber.new(country_code: "+1", main: "0987654321")
    contact.email_addresses << [ email1, email2 ]
    contact.phone_numbers << [ phone1, phone2 ]

    assert contact.save_with_children
    assert contact.persisted?
    assert_equal 2, contact.email_addresses.count
    assert_equal 2, contact.phone_numbers.count
  end
end
