class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  
  has_many :schedules, dependent: :destroy
  
  before_save { self.email = email.downcase }
  validates :username, presence: true
  validates :email   , presence: true
end
