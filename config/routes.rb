Rails.application.routes.draw do
  root to: 'pages#home'

  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :kanjis, only: [ :index, :show ]
      resources :user_kanjis
    end
  end
end
