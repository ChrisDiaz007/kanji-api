Rails.application.routes.draw do
  root to: 'pages#home'
  devise_for :users

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :kanjis, only: [ :index, :show ]
      resources :user_kanjis
    end
  end
end
