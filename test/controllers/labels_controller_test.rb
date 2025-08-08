require "test_helper"

class LabelsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    token = token_from(users(:one))
    @headers = {
      "Authorization" => "Bearer #{token}"
    }
  end

  test "should get index" do
    get labels_url, headers: @headers
    assert_response :success
    response_data = JSON.parse(response.body)
    assert response_data["data"].is_a?(Array)
    assert_equal users(:one).labels.count, response_data["data"].size
  end

  test "should create label" do
    label_params = {
      label: {
        name: "New Label"
      }
    }
    assert_difference("Label.count") do
      post labels_url, params: label_params, headers: @headers
    end
    assert_response :created
    response_data = JSON.parse(response.body)
    assert_equal "New Label", response_data["data"]["name"]
  end

  test "should update label" do
    label = labels(:work)
    label_params = {
      label: {
        name: "Updated Label"
      }
    }
    patch label_url(label.identifier), params: label_params, headers: @headers
    assert_response :ok
    response_data = JSON.parse(response.body)
    assert_equal "Updated Label", response_data["data"]["name"]
  end

  test "should destroy label" do
    label = labels(:work)
    assert_difference("Label.count", -1) do
      delete label_url(label.identifier), headers: @headers
    end
    assert_response :no_content
  end
end
