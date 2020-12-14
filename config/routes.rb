Rails.application.routes.draw do
    resources :cards
    resources :lists
    namespace :admin do
        resources :users

        root to: "users#index"
    end

    resources :cards do
        member do
            patch :move
        end
    end
    resources :lists do
        member do
            patch :move
        end
    end

    devise_for :users, controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
    }

    root 'lists#index'
    get 'terms', to: 'home#terms'
end
