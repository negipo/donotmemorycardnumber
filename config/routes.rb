Rails.application.routes.draw do
  resources :friends, only: %i(index show update) do
    collection do
      post :assign_numbers
    end

    member do
      put :assign_number
      put :withdraw_number
    end
  end

  devise_for :users,
    controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  root to: "home#index"
end
