class VotesController < ApplicationController
  before_action :require_authentication

  def create
    event = Event.find(params[:event_id])  # Fetch the event
    vote_type = params[:vote_type]  # 'up' or 'down'

    # Increment vote counts based on vote type
    if vote_type == "up"
      event.increment!(:upvotes)
      # Publish the EventUpvoted event
      event_upvoted = EventUpvoted.new(data: { user_id: current_user.id, event_id: event.id })
      Rails.configuration.event_system.publish(event_upvoted)  # Custom event system
    else
      event.increment!(:downvotes)
      # Publish the EventDownvoted event
      event_downvoted = EventDownvoted.new(data: { user_id: current_user.id, event_id: event.id })
      Rails.configuration.event_system.publish(event_downvoted)  # Custom event system
    end

    redirect_to events_path, notice: "Your vote has been recorded!"
  end

  private

  def require_authentication
    redirect_to root_path, alert: "You must be logged in to vote." unless current_user
  end
end
