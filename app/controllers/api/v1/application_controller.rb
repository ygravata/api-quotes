class Api::V1::ApplicationController < ApplicationController
  # method to authenticate token
  acts_as_token_authentication_handler_for User

  rescue_from StandardError,                with: :internal_server_error

  private
  # a set of errors to be raised, if anyhting goes wrong with the api
  def not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def internal_server_error(exception)
    if Rails.env.development?
      response = { type: exception.class.to_s, message: exception.message, backtrace: exception.backtrace }
    else
      response = { error: "Internal Server Error" }
    end
    render json: response, status: :internal_server_error
  end
end
