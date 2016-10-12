Rails.application.routes.draw do
  root to: 'static_pages#home'
  get '/about', to: 'static_pages#about', as: :about
  # new game        POST request                    /game/new
  match '/game/new', to: 'game#new', via: [:post], as: :new_game
  # join game         POST request                  /game/id/join
  match '/game/join', to: 'game#join', via: [:post], as: :join_game
  # result                GET request                      /game/id/result
  match '/game/:id/result', to: 'game#result', via: [:get], as: :result_game
  # status                GET request                     /game/id
  match '/game/:id/status', to: 'game#status', via: [:get], as: :status_game
  # delete game     DELETE request                /game/id
  match '/game/:id', to: 'game#delete', via: [:delete], as: :delete_game
  # update              PATCH request                 /game/id
  match '/game/:id', to: 'game#update', via: [:patch], as: :update_game
end
