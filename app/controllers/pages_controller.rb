# frozen_string_literal: true

class PagesController < ApplicationController
  def home; end

  def workschedule; end

  def requestschedule
    @requestschedule = Schedule.new
  end

  def approveschedule; end
end
