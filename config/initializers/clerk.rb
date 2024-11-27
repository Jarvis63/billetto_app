
Clerk.configure do |config|
  config.api_key = ENV["CLERK_SECRET_KEY"]
end

#Clerk.api_version = "v1"  # Optional, set your Clerk API version if needed
