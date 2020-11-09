# frozen_string_literal: true

Rails.application.routes.draw do
  root   'pages#home'
  get    'users/adminsettings'
  get    'schedules/workschedule'
  get    'schedules/requestschedule'
  get    'schedules/approveschedule'
  get    'schedules/editschedule'
  patch  'schedules/:id/update_to_edit_schedule' => 'schedules#update_to_edit_schedule'

  devise_for :users
  resources :users, :only => [:update, :destroy] # adminsettings用
  resources :schedules
  resources :stores
end
