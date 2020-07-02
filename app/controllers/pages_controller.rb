# frozen_string_literal: true

class PagesController < ApplicationController
  # before_action :authenticate_user!

  def home
  end

  def workschedule; end

  def requestschedule
    @requestschedule = Schedule.new
    @stores = Store.all
    @schedules = Schedule.all
    @user = User.find_by(id: current_user.id)
    # @user = User.find_by(id: user_id)
    # @store = Store.find_by(id: @schedule.store_id)
  end

  def approveschedule
    # @user = User.find_by(id: current_user.id)
    @stores = Store.all
    @schedules = Schedule.all
  end
end
