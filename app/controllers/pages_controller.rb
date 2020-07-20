# frozen_string_literal: true

class PagesController < ApplicationController
  # before_action :authenticate_user!

  def home; end

  def beforemonth
    
  end

  def nextmonth
    # @beginningday = @beginningday >> 1
    # @beginningday = @beginningday + '0000/01/00'
  end
end
