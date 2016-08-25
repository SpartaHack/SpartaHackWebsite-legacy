# == Route Map
#
#     Prefix Verb   URI Pattern              Controller#Action
# home_index GET    /home(.:format)          home#index
#            POST   /home(.:format)          home#create
#   new_home GET    /home/new(.:format)      home#new
#  edit_home GET    /home/:id/edit(.:format) home#edit
#       home GET    /home/:id(.:format)      home#show
#            PATCH  /home/:id(.:format)      home#update
#            PUT    /home/:id(.:format)      home#update
#            DELETE /home/:id(.:format)      home#destroy
#       root GET    /                        home#index
#

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :home
  root "home#index"
end
