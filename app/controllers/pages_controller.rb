# frozen_string_literal: true

class PagesController < ApplicationController
  # before_action :authenticate_user!

  def home; end

  def new_guest
    user = User.find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.confirmed_at = Time.now
      user.username = "ゲストユーザー（一般権限）"
      user.duty_hours = 0
      user.admin = false
    end
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザー（一般権限）としてログインしました。'
  end

  def new_guest_admin
    user = User.find_or_create_by!(email: 'guest_admin@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.confirmed_at = Time.now
      user.username = "ゲストユーザー（店長権限）"
      user.duty_hours = 5
      user.admin = true
    end
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザー（店長権限）としてログインしました。'
  end

end
