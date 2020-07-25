# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
 
  root 'pages#home'
  # get  'pages/workschedule'
  # get  'pages/requestschedule'
  # get  'pages/approveschedule'
  # get  'pages/addstores'
  get  'schedules/workschedule'
  get  'schedules/requestschedule'
  get  'schedules/approveschedule'
  get  'users/adminsettings'
  post  'schedules/updateadmin'

  get  'schedules/beforemonth'
  get  'schedules/nextmonth'

  # post 'schedules', to: 'pages#requestschedule'
  # resources :schedules, only: [:create, :destory]
  resources :schedules
  # resources :schedules do
    # collection do
      # match 'calendersearch' => 'schedules#calendersearch', via: [:get, :post]
      # match 'calendersearch' => 'schedules#calendersearch'
    # end
  # end
  resources :users, only: [:update]
  resources :stores
 
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root 'application#hello'
  
  # Rails.application.routes.draw do
  get 'users/new'
  #   devise_for :users, controllers: {
  #     sessions: 'users/sessions'
  #   }
  # end
end
