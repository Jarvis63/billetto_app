require "clerk"
require "net/http"
require "uri"
require "json"
class SessionsController < ApplicationController
  def new
    # This action will render the login form (root of the app)
  end

  def create
    user_id = params[:email]
    password = params[:password]

    puts user_id, password, ENV["CLERK_SECRET_KEY"]

    begin
      # Define the Clerk API endpoint
      uri = URI("https://api.clerk.dev/v1/sessions?user_id=#{user_id}")

      # Prepare the request
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.path)
      request["Authorization"] = "Bearer #{ENV['CLERK_SECRET_KEY']}"
      request["Content-Type"] = "application/json"
      request.body = { user_id: user_id, password: password }.to_json

      # Make the API request
      response = http.request(request)
      result = JSON.parse(response.body)

      if response.code == "200"
        # Store the session token or user information as needed

        session[:session_token] = result["id"]  # Assuming this is the session token

        redirect_to events_index_path, notice: "Successfully logged in!" # Redirect on success
      else
        flash.now[:alert] = "Invalid credentials or user not found"
        render :new
      end

    rescue StandardError => e
      flash.now[:alert] = "An error occurred: #{e.message}"
      render :new
    end
  end



  def destroy
    session[:user_id] = nil  # Log out by clearing the session
    redirect_to root_path  # Redirect to the login page after logout
  end
end
