# frozen_string_literal: true

Exceptio::Engine.routes.draw do
  root to: 'exceptions#index'
  resources :exceptions do
    collection do
      post :delete_all
    end
  end
end
