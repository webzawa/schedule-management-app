# frozen_string_literal: true

class PagesController < ApplicationController
  # before_action :authenticate_user!

  def home
  end

  def workschedule; end

  def requestschedule
    @requestschedule = Schedule.new
  end

  def approveschedule; end
end
