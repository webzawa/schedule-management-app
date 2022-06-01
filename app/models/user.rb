class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :timeoutable

  attr_accessor :paying_signup_flag

  has_many :schedules, :dependent => :destroy

  validates :username, :presence => true, :length => { :maximum => 20 }

  before_save { self.email = email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  validates :email, :presence => true, :length => { :maximum => 255 },
                    :format => { :with => VALID_EMAIL_REGEX },
                    :uniqueness => { :case_sensitive => false }

  validates :comment, :length => { :maximum => 255 }

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.confirmed_at = Time.now
      user.username = 'ゲスト(一般)'
      user.duty_hours = 0
      user.admin = false
    end
  end

  def self.guest_admin
    find_or_create_by!(:email => 'guest_admin@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.confirmed_at = Time.now
      user.username = 'ゲスト(店長)'
      user.duty_hours = 5
      user.admin = true
    end
  end
end
