# frozen_string_literal: true

Rails.application.routes.draw do
  root 'pages#home'
  get  'users/adminsettings'
  get  'schedules/workschedule'
  get  'schedules/requestschedule'
  get  'schedules/approveschedule'

  devise_for :users
  resources :users, only: [:update] # adminsettings用
  resources :schedules
  resources :stores
end
