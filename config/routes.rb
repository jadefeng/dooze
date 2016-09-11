GifVault::Application.routes.draw do

  get "snoozes/first"
  get "snoozes/second"
  get "snoozes/third"
  post '/sms' => 'snoozes#sms'
  # root to: 'gif#cool'
  root to: 'transactions#new'
   
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  resources :transactions, only: [:new, :create]

  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  get '/users/edit' => 'users#edit'
  get '/users' => 'users#show'
  get '/users/addTime' => 'users#addTime'
  post '/users/addTime' => 'users#addTime'



  get '/cool' => 'gif#cool'  
  get '/sweet' => 'gif#sweet'

end