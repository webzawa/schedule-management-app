# frozen_string_literal: true

Rails.application.routes.draw do
  root   'pages#home'
  get    'users/adminsettings'
  get    'schedules/workschedule'
  get    'schedules/requestschedule'
  get    'schedules/approveschedule'
  get    'schedules/editschedule'
  patch  'schedules/:id/update_to_edit_schedule' => 'schedules#update_to_edit_schedule'
  post   'users/:id/update_confirmed_at' => 'users#update_confirmed_at'
  post   '/pages/guest_sign_in', to: 'pages#new_guest'
  post   '/pages/guest_admin_sign_in', to: 'pages#new_guest_admin'

  devise_for :users
  resources :users, :only => [:update, :destroy] # adminsettings用
  resources :schedules
  resources :stores
  resources :schedule_checkboxes
end
