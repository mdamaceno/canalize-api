require "test_helper"

class PhoneNumbersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    token = token_from(users(:one))
    @headers = {
      "Authorization" => "Bearer #{token}"
    }
  end

  test "should get index" do
    contact = contacts(:one)
    get contact_phone_numbers_url(contact.identifier), headers: @headers
    assert_response :success
    response_data = JSON.parse(response.body)
    assert response_data["data"].is_a?(Array)
    assert_equal contact.phone_numbers.count, response_data["data"].size
  end

  test "should create phone number" do
    contact = contacts(:one)
    main = "2888999999"
    phone_number_params = {
      phone_number: {
        main: main,
        country_code: 1,
        label_id: labels(:work).id
      }
    }
    assert_difference("PhoneNumber.count") do
      post contact_phone_numbers_url(contact.identifier), params: phone_number_params, headers: @headers
    end
    assert_response :created
    response_data = JSON.parse(response.body)
    assert_equal main, response_data["data"]["main"]
    assert_equal "+1", response_data["data"]["country_code"]
  end

  test "should update phone number" do
    contact = contacts(:one)
    phone_number = contact.phone_numbers.first
    main = "2888999999"
    phone_number_params = {
      phone_number: {
        main: main,
        country_code: 55,
        label_id: labels(:personal).id
      }
    }
    patch contact_phone_number_url(contact.identifier, phone_number.identifier), params: phone_number_params, headers: @headers
    assert_response :ok
    response_data = JSON.parse(response.body)
    assert_equal main, response_data["data"]["main"]
    assert_equal "+55", response_data["data"]["country_code"]
  end

  test "should destroy phone number" do
    contact = contacts(:one)
    phone_number = contact.phone_numbers.first
    assert_difference("PhoneNumber.count", -1) do
      delete contact_phone_number_url(contact.identifier, phone_number.identifier), headers: @headers
    end
    assert_response :no_content
  end
end
