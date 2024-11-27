namespace :events do
  desc "Import events from Billetto API"
  task import: :environment do
    puts "Fetching events from Billetto API..."

    events = BillettoApiService.fetch_events

    if events.is_a?(Array)
      events.each do |event|
        # Assuming you have a Rails model `Event` to save the event data
        Event.find_or_create_by(
          external_id: event["id"]
        ) do |e|
          e.title = event["name"]  # Assuming `name` corresponds to your `title`
          e.date = event["starts_at"]  # You can adjust to use `ends_at` if needed
          e.image_url = event.dig("images", 0, "url") # Safely access image URL if available
          e.description = event["description"] || "No description provided" # Handle missing data
        end
      end
      puts "Events imported successfully."
    else
      puts "Unexpected response format: #{events.inspect}"
    end
  rescue StandardError => e
    puts "Error importing events: #{e.message}"
  end
end
