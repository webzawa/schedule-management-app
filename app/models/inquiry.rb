class Inquiry < ApplicationRecord
  validates  :request_comment, :presence => true
  validates  :request_comment, :length => { :maximum => 10000  }
end
