class ScheduleCheckbox < ApplicationRecord
  validates :name_for_checkbox, :presence => true, :length => { :maximum => 10 }
end
