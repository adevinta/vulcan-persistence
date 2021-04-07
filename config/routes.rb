# Copyright 2019 Adevinta

Rails.application.routes.draw do
  scope module: 'api' do
    namespace :v1 do
      resources :jobqueues
      resources :assettypes
      resources :checktypes
    end
  end
  get 'status' => 'healthchecks#health'
end
