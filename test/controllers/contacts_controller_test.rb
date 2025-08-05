require "test_helper"

class ContactsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should create contact with valid attributes" do
    token = token_from(users(:one))

    post contacts_url, params: {
      contact: {
        first_name: "Jane",
        last_name: "Smith",
        birthdate: "1990-01-01",
        email_addresses: [{ email: "email1@email.com"}],
        phone_numbers: [{ country_code: "+55", main: "1234567890" }]
      },
    }, headers: {
      "Authorization" => "Bearer #{token}",
    }

    assert_response :created
    response_data = JSON.parse(response.body)
    assert response_data["data"].present?
    contact = Contact.find(response_data["data"]["id"])
    assert_equal "Jane", contact.first_name
    assert_equal "Smith", contact.last_name
    assert_equal "1990-01-01", contact.birthdate.to_s
    assert_equal 1, contact.email_addresses.count
    assert_equal 55, contact.phone_numbers.first.country_code
    assert_equal "1234567890", contact.phone_numbers.first.main
    assert_equal 1, contact.phone_numbers.count
  end
end
