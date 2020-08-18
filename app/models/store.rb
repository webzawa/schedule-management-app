class Store < ApplicationRecord
  has_many  :schedules, :dependent => :destroy
  validates :storename, :presence => true
end
