# frozen_string_literal: true

Rails.application.routes.draw do
  root   'pages#home'
  get    'users/adminsettings'
  get    'schedules/workschedule'
  get    'schedules/requestschedule'
  get    'schedules/approveschedule'
  get    'schedules/editschedule'
  get    'schedules/originalschedule'
  patch  'schedules/:id/update_to_edit_schedule' => 'schedules#update_to_edit_schedule'
  patch  'users/:id/update_to_comment'   => 'users#update_to_comment'
  post   'users/:id/update_confirmed_at' => 'users#update_confirmed_at'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
    post 'users/guest_admin_sign_in', to: 'users/sessions#new_guest_admin'
  end

  resources :users, :only => [:update, :destroy] # adminsettings用
  resources :schedules
  resources :stores
  resources :schedule_checkboxes
  resources :inquiries
end
