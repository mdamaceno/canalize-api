class UsersController < ApplicationController
  before_action :authenticate_user!

  def me
    user = current_user

    if user
      render json: {
        id: user.identifier,
        email: user.email,
        name: user.name,
        created_at: user.created_at,
        updated_at: user.updated_at
      }, status: :ok
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end
end
