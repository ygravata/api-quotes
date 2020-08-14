Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :quotes
      post '/quotes/:search_tag', to: 'quotes#search', as: 'quotes_search'
    end
  end  
end
