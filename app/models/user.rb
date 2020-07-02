class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :schedules
  
  before_save { self.email = email.downcase }
  validates :username, presence: true
  validates :email   , presence: true
end
