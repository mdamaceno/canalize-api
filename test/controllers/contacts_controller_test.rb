require "test_helper"

class ContactsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @token = token_from(users(:one))
  end

  test "should get index" do
    get contacts_url, headers: { "Authorization" => "Bearer #{@token}" }
    assert_response :success

    response_data = JSON.parse(response.body)
    assert response_data["data"].present?
    assert response_data["data"].is_a?(Array)
    assert response_data["data"].first["identifier"].present?
  end

  test "should show contact" do
    contact = contacts(:one)
    get contact_url(contact.identifier), headers: { "Authorization" => "Bearer #{@token}" }

    assert_response :success
    response_data = JSON.parse(response.body)
    assert response_data["data"].present?
    assert_equal contact.identifier, response_data["data"]["identifier"]
    assert_equal contact.first_name, response_data["data"]["first_name"]
    assert_equal contact.last_name, response_data["data"]["last_name"]
    assert_equal contact.birthdate.to_s, response_data["data"]["birthdate"]
    assert response_data["data"]["email_addresses"].is_a?(Array)
    assert response_data["data"]["phone_numbers"].is_a?(Array)
  end

  test "should create contact with valid attributes" do
    post contacts_url, params: {
      contact: {
        first_name: "Jane",
        last_name: "Smith",
        birthdate: "1990-01-01",
        email_addresses: [ { email: "email1@email.com" } ],
        phone_numbers: [ { country_code: "+55", main: "1234567890" } ]
      }
    }, headers: {
      "Authorization" => "Bearer #{@token}"
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

  test "should not create contact with invalid attributes" do
    post contacts_url, params: {
      contact: {
        first_name: "",
        last_name: "Invalid",
        birthdate: "not-a-date",
        email_addresses: [ { email: "invalid-email" } ],
        phone_numbers: [ { country_code: "invalid", main: "123" } ]
      }
    }, headers: {
      "Authorization" => "Bearer #{@token}"
    }

    assert_response :unprocessable_content
    response_data = JSON.parse(response.body)
    assert response_data["errors"].present?
    assert_includes response_data["errors"], "First name can't be blank"
  end

  test "should update contact with valid attributes" do
    contact = contacts(:one)

    patch contact_url(contact.identifier), params: {
      contact: {
        first_name: "Updated",
        last_name: "Name",
        birthdate: "1995-05-05"
      }
    }, headers: {
      "Authorization" => "Bearer #{@token}"
    }

    assert_response :success
    response_data = JSON.parse(response.body)
    assert response_data["data"].present?
    contact.reload
    assert_equal "Updated", contact.first_name
    assert_equal "Name", contact.last_name
    assert_equal "1995-05-05", contact.birthdate.to_s
  end

  test "should not update contact with invalid attributes" do
    contact = contacts(:one)

    patch contact_url(contact.identifier), params: {
      contact: {
        first_name: "",
        last_name: "Invalid",
        birthdate: "not-a-date"
      }
    }, headers: {
      "Authorization" => "Bearer #{@token}"
    }

    assert_response :unprocessable_content
    response_data = JSON.parse(response.body)
    assert response_data["errors"].present?
    assert_includes response_data["errors"], "First name can't be blank"
  end

  test "should destroy contact" do
    contact = contacts(:one)

    assert_difference("Contact.count", -1) do
      delete contact_url(contact.identifier), headers: { "Authorization" => "Bearer #{@token}" }
    end

    assert_response :no_content
    assert_not Contact.exists?(contact.id), "Contact should be deleted"
  end
end
