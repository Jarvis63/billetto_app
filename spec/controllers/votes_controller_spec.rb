require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) } 
  let(:event) { create(:event) }  

  before do
    # Simulate user being logged in
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'POST #create' do
    context 'when user is authenticated' do
      it 'upvotes an event and publishes the EventUpvoted event' do
        # Stub the event system to prevent errors
        allow(Rails.configuration.event_system).to receive(:publish)

        # Perform the upvote
        post :create, params: { event_id: event.id, vote_type: 'up' }

        # Reload the event to get the updated vote count
        event.reload

        # Check if the event's upvotes were incremented
        expect(event.upvotes).to eq(1)
        expect(event.downvotes).to eq(0)

        # Verify that the EventUpvoted event was published
        expect(Rails.configuration.event_system).to have_received(:publish).once
      end

      it 'downvotes an event and publishes the EventDownvoted event' do
        # Stub the event system to prevent errors
        allow(Rails.configuration.event_system).to receive(:publish)

        # Perform the downvote
        post :create, params: { event_id: event.id, vote_type: 'down' }

        # Reload the event to get the updated vote count
        event.reload

        # Check if the event's downvotes were incremented
        expect(event.upvotes).to eq(0)
        expect(event.downvotes).to eq(1)

        # Verify that the EventDownvoted event was published
        expect(Rails.configuration.event_system).to have_received(:publish).once
      end
    end

    context 'when user is not authenticated' do
      before do
        # Simulate user not being logged in
        allow(controller).to receive(:current_user).and_return(nil)
      end

      it 'redirects to the root path with an alert' do
        post :create, params: { event_id: event.id, vote_type: 'up' }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You must be logged in to vote.')
      end
    end
  end
end
