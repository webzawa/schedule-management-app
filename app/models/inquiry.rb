class Inquiry < ApplicationRecord
  validates  :request_comment, :presence => true
end
