# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
 
  root 'pages#home'
  get  'pages/workschedule'
  get  'pages/requestschedule'
  get  'pages/approveschedule'

  # post 'schedules', to: 'pages#requestschedule'
  # resources :schedules, only: [:create, :destory]
  resources :schedules
 
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root 'application#hello'
  
  # Rails.application.routes.draw do
  #   devise_for :users, controllers: {
  #     sessions: 'users/sessions'
  #   }
  # end
end
