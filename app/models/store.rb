class Store < ApplicationRecord
  has_many :schedules, :dependent => :destroy
end
