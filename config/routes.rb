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
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
    post 'users/guest_admin_sign_in', to: 'users/sessions#new_guest_admin'
    get 'users/paying_user_sign_in', to: 'users/registrations#new_paying'
  end

  resources :users, :only => [:update, :destroy] # adminsettings用
  resources :schedules
  resources :stores
  resources :schedule_checkboxes
  resources :inquiries

  resources :payments, only: [:new]
  get '/payments/after_payment_register', controller: 'payments', action: 'after_payment_register'
  get '/payments/payment_cancel', controller: 'payments', action: 'payment_cancel'

end
