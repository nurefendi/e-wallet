module ExceptionHandler
    extend ActiveSupport::Concern
  
    # Define custom error subclasses - rescue catches `StandardErrors`
    class RecordInvalid < StandardError; end
    class AuthenticationError < StandardError; end
    class MissingToken < StandardError; end
    class InvalidToken < StandardError; end
    class ParamsRequired < StandardError; end
  
    included do
      # Define custom handlers
      rescue_from ExceptionHandler::RecordInvalid, with: :four_twenty_two
      rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
      rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
      rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two
      rescue_from ExceptionHandler::ParamsRequired, with: :params_required
  
      rescue_from ActiveRecord::RecordNotFound do |e|
        json_response({ message: e.message }, :not_found)
      end
    end
  
    private
  
    # JSON response with message; Status code 422 - unprocessable entity
    def four_twenty_two(e)
      json_response({ message: e.message }, :unprocessable_entity)
    end
  
    # JSON response with message; Status code 401 - Unauthorized
    def unauthorized_request(e)
      json_response({ message: e.message }, :unauthorized)
    end

    def params_required(e)
      json_response({message: e.message}, :unprocessable_entity)
    end
  end