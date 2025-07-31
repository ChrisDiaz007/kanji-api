Rails.application.routes.draw do
  root to: 'pages#home'


  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_for :users, path: '', path_names: {
        sign_in: 'login',
        sign_out: 'logout',
        registration: 'signup'
      },
      controllers: {
        sessions: 'api/v1/sessions',
        registrations: 'api/v1/registrations'
      }

      resources :kanjis, only: [ :index, :show ]
      resources :user_kanjis
    end
  end
end
