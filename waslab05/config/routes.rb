Rails.application.routes.draw do
  resources :tweets do
    member do
      put 'like' 
   end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'tweets#index'
end
