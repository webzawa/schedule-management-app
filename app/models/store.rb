class Store < ApplicationRecord
  has_many  :schedules, :dependent => :destroy

  validates :storename, :presence => true, :length => { :maximum => 20 }
end
