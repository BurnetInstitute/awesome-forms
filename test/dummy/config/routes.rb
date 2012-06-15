Dummy::Application.routes.draw do
  resources :people, only: [:new, :create]

  root to: 'people#new'
end
