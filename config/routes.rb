Rails.application.routes.draw do
  root 'generation#index'

  resources :generation do
    collection do
      post :upload_file
      post :search_by_token
      post :update_dictionary
    end
  end
end
