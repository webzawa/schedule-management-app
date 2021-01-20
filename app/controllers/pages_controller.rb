# frozen_string_literal: true

class PagesController < ApplicationController
  # before_action :authenticate_user!

  def home
    @inquiry = Inquiry.new
  end
end
