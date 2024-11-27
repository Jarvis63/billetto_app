require 'rails_helper'

RSpec.describe Event, type: :model do
  # Test valid event creation
  it 'is valid with valid attributes' do
    event = Event.new(title: 'Test Event', date: '2024-12-31')
    expect(event).to be_valid
  end

  # Test presence validation for title
  it 'is invalid without a title' do
    event = Event.new(title: nil, date: '2024-12-31')
    expect(event).not_to be_valid
    expect(event.errors[:title]).to include("can't be blank")
  end

  # Test presence validation for date
  it 'is invalid without a date' do
    event = Event.new(title: 'Test Event', date: nil)
    expect(event).not_to be_valid
    expect(event.errors[:date]).to include("can't be blank")
  end

  # Test presence validation for both title and date
  it 'is invalid without both a title and a date' do
    event = Event.new(title: nil, date: nil)
    expect(event).not_to be_valid
    expect(event.errors[:title]).to include("can't be blank")
    expect(event.errors[:date]).to include("can't be blank")
  end
end
