# frozen_string_literal: true

class PagesController < ApplicationController
  # before_action :authenticate_user!

  def home; end

  def workschedule
    @schedules = Schedule.all
    @beginningday = Date.today.beginning_of_month
    @endday       = Date.today.end_of_month
    @beginningtoendday = @beginningday..@endday
    @users = User.all
    @schedules = Schedule.all
  end

  def requestschedule
    @requestschedule = Schedule.new
    # @stores = Store.all
    @schedules = Schedule.all.order(request_day: 'DESC')
    @user = User.find_by(id: current_user.id)
    # @user = User.find_by(id: user_id)
    # @store = Store.find_by(id: @schedule.store_id)
  end

  def approveschedule
    # @user = User.find_by(id: current_user.id)
    # @stores = Store.all
    @schedules = Schedule.all.order(request_day: 'DESC')
    @approveschedules = Schedule.new
  end

  def addstores
    @store  = Store.new
    @stores = Store.all
  end
end
