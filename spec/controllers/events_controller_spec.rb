# spec/controllers/events_controller_spec.rb
require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  # Test for the index action
  describe 'GET #index' do
    it 'assigns @events and renders the index template' do
      # Create some events using FactoryBot
      event1 = FactoryBot.create(:event)
      event2 = FactoryBot.create(:event)

      # Send a GET request to the index action
      get :index

      # Check if @events contains the events created
      expect(assigns(:events)).to match_array([event1, event2])

      # Ensure the correct template is rendered
      expect(response).to render_template(:index)
    end
  end

  # Test for the import action
  describe 'POST #import' do
    it 'runs the rake task and redirects to the events index' do
      # You can mock the system call for the rake task to avoid actually running it
      allow_any_instance_of(EventsController).to receive(:system).and_return(true)

      # Send a POST request to the import action
      post :import

      # Check that the redirect happens
      expect(response).to redirect_to(events_path)

      # Ensure the flash notice contains the expected message
      expect(flash[:notice]).to eq("Events are being imported...")
    end
  end
end
