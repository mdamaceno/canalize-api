ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    def token_from(user)
      post user_session_path, params: {
        user: {
          email: user.email,
          password: "password" # Assuming the password is "password" for test users
        }
      }
      assert_response :success, "Failed to log in as #{user.email}"

      token = response.headers["authorization"]

      token.gsub(/Bearer /, "")
    end
  end
end
