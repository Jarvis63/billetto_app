class BillettoApiService
  BASE_URL = "https://billetto.com/api/v3/organiser/events"

  def self.fetch_events
    url = URI(BASE_URL)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = "application/json"
    request["Api-Keypair"] = "#{ENV["BILLETTO_API_KEY"]}:#{ENV["BILLETTO_API_SERCERT"]}"

    response = http.request(request)

    raise "API Request Failed: #{response.code} - #{response.message}" unless response.code.to_i == 200

    parsed_response = JSON.parse(response.body)
    puts "API Response: #{parsed_response.inspect}"

    # Return the list of events from `data` or an empty array if missing
    parsed_response["data"] || []
  rescue JSON::ParserError => e
    puts "Error parsing JSON response: #{e.message}"
    []
  rescue StandardError => e
    puts "Error fetching events: #{e.message}"
    []
  end
end
