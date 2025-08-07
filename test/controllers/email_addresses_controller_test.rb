require "test_helper"

class EmailAddressesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    token = token_from(users(:one))
    @headers = {
      "Authorization" => "Bearer #{token}"
    }
  end

  test "should get index" do
    contact = contacts(:one)
    get contact_email_addresses_url(contact.identifier), headers: @headers
    assert_response :success
    response_data = JSON.parse(response.body)
    assert response_data["data"].is_a?(Array)
    assert_equal contact.email_addresses.count, response_data["data"].size
  end

  test "should create email address" do
    contact = contacts(:one)
    email_address_params = {
      email_address: {
        email: "email-test1@email.com",
        label_id: labels(:work).id
      }
    }
    assert_difference("EmailAddress.count") do
      post contact_email_addresses_url(contact.identifier), params: email_address_params, headers: @headers
    end
    assert_response :created
    response_data = JSON.parse(response.body)
    assert_equal "email-test1@email.com", response_data["data"]["email"]
  end

  test "should update email address" do
    contact = contacts(:one)
    email_address = contact.email_addresses.first
    email_address_params = {
      email_address: {
        email: "email-updated@email.com",
        label_id: labels(:personal).id
      }
    }
    patch contact_email_address_url(contact.identifier, email_address.identifier), params: email_address_params, headers: @headers
    assert_response :ok
    response_data = JSON.parse(response.body)
    assert_equal "email-updated@email.com", response_data["data"]["email"]
  end

  test "should destroy email address" do
    contact = contacts(:one)
    email_address = contact.email_addresses.first
    assert_difference("EmailAddress.count", -1) do
      delete contact_email_address_url(contact.identifier, email_address.identifier), headers: @headers
    end
    assert_response :no_content
  end
end
