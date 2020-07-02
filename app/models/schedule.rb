class Schedule < ApplicationRecord
  belongs_to :user
  belongs_to :store
  validates :request_day, presence: true
  # validates :request_timezone, presence: true
end
