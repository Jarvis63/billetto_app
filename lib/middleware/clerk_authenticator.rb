require "jwt"
require "net/http"
require "json"

class ClerkAuthenticator
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    token = request.get_header("HTTP_AUTHORIZATION")&.split(" ")&.last

    if token && valid_clerk_token?(token)
      env["clerk.user"] = decode_token(token) # Pass the decoded user info in the environment
      @app.call(env)
    else
      [ 401, { "Content-Type" => "application/json" }, [ { error: "Unauthorized" }.to_json ] ]
    end
  end

  private

  def valid_clerk_token?(token)
    secret_key = ENV["CLERK_SECRET_KEY"]
    return false unless secret_key

    begin
      decoded_token = JWT.decode(token, secret_key, true, { algorithm: "HS256" })
      decoded_token.present?
    rescue JWT::DecodeError
      false
    end
  end

  def decode_token(token)
    secret_key = ENV["CLERK_SECRET_KEY"]
    JWT.decode(token, secret_key, true, { algorithm: "HS256" }).first
  end
end
