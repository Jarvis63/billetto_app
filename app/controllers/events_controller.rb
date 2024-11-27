

class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def import
    # Run the rake task to import events
    system("rails events:import")

    # Redirect back to the events index page after importing
    redirect_to events_path, notice: "Events are being imported..."
  end
end
