# frozen_string_literal: true

Rails.application.routes.draw do
  root 'pages#home'
  get  'pages/workschedule'
  get  'pages/requestschedule'
  get  'pages/approveschedule'
  post 'schedules', to: 'pages#requestschedule'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root 'application#hello'
end
