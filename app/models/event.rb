class Event < ApplicationRecord
  validates :title, :date, presence: true
end
