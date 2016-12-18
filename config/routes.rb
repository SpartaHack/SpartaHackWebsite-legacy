# == Route Map
#
#           Prefix Verb   URI Pattern                      Controller#Action
#       home_index GET    /home(.:format)                  home#index
#                  POST   /home(.:format)                  home#create
#         new_home GET    /home/new(.:format)              home#new
#        edit_home GET    /home/:id/edit(.:format)         home#edit
#             home GET    /home/:id(.:format)              home#show
#                  PATCH  /home/:id(.:format)              home#update
#                  PUT    /home/:id(.:format)              home#update
#                  DELETE /home/:id(.:format)              home#destroy
#        subscribe POST   /subscribe(.:format)             home#subscribe
#    rememberTheme POST   /rememberTheme(.:format)         home#rememberTheme
#       user_index GET    /user(.:format)                  user#index
#                  POST   /user(.:format)                  user#create
#         new_user GET    /user/new(.:format)              user#new
#        edit_user GET    /user/:id/edit(.:format)         user#edit
#             user GET    /user/:id(.:format)              user#show
#                  PATCH  /user/:id(.:format)              user#update
#                  PUT    /user/:id(.:format)              user#update
#                  DELETE /user/:id(.:format)              user#destroy
#        dashboard GET    /dashboard(.:format)             user#dashboard
#            admin GET    /admin(.:format)                 admin#dashboard
#        admin_faq GET    /admin/faq(.:format)             admin#faq
#   admin_faq_view GET    /admin/faq/view(.:format)        admin#faq_view
# admin_statistics GET    /admin/statistics(.:format)      admin#statistics
#            stats GET    /stats(.:format)                 admin#stats
#     applications GET    /applications(.:format)          applications#index
#                  POST   /applications(.:format)          applications#create
#  new_application GET    /applications/new(.:format)      applications#new
# edit_application GET    /applications/:id/edit(.:format) applications#edit
#      application GET    /applications/:id(.:format)      applications#show
#                  PATCH  /applications/:id(.:format)      applications#update
#                  PUT    /applications/:id(.:format)      applications#update
#                  DELETE /applications/:id(.:format)      applications#destroy
#            apply GET    /apply(.:format)                 applications#new
#                  GET    /application(.:format)           applications#new
#                  POST   /application(.:format)           applications#create
# application_edit GET    /application/edit(.:format)      applications#edit
#                  PUT    /application(.:format)           applications#update
#       rsvp_index GET    /rsvp(.:format)                  rsvp#index
#                  POST   /rsvp(.:format)                  rsvp#create
#         new_rsvp GET    /rsvp/new(.:format)              rsvp#new
#        edit_rsvp GET    /rsvp/:id/edit(.:format)         rsvp#edit
#             rsvp GET    /rsvp/:id(.:format)              rsvp#show
#                  PATCH  /rsvp/:id(.:format)              rsvp#update
#                  PUT    /rsvp/:id(.:format)              rsvp#update
#                  DELETE /rsvp/:id(.:format)              rsvp#destroy
#                  GET    /rsvp(.:format)                  rsvp#new
#            login GET    /login(.:format)                 sessions#new
#                  POST   /login(.:format)                 sessions#create
#           logout GET    /logout(.:format)                sessions#destroy
#          destroy POST   /destroy(.:format)               user#destroy
#             root GET    /                                home#index
#     batch_create POST   /batch/create(.:format)          batch#create
#    batch_destroy POST   /batch/destroy(.:format)         batch#destroy
#     batch_update POST   /batch/update(.:format)          batch#update
#             faqs GET    /faqs(.:format)                  faqs#index
#                  POST   /faqs(.:format)                  faqs#create
#          new_faq GET    /faqs/new(.:format)              faqs#new
#         edit_faq GET    /faqs/:id/edit(.:format)         faqs#edit
#              faq GET    /faqs/:id(.:format)              faqs#show
#                  PATCH  /faqs/:id(.:format)              faqs#update
#                  PUT    /faqs/:id(.:format)              faqs#update
#                  DELETE /faqs/:id(.:format)              faqs#destroy
#

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :home
  post "/subscribe", to: 'home#subscribe'
  post "/rememberTheme", to: 'home#rememberTheme'

  resources :user
  get '/dashboard', to: 'user#dashboard'
  get '/admin', to: 'admin#dashboard'
  get '/admin/faq', to: 'admin#faq'
  get '/admin/faq/view', to: 'admin#faq_view'
  get '/admin/sponsorship', to: 'admin#sponsorship'
  get '/admin/sponsorship/view', to: 'admin#sponsorship'
  post '/admin/sponsorship/view', to: 'admin#sponsorship_view'
  get '/admin/statistics', to: 'admin#statistics'
  get '/stats', to: 'admin#stats'

  resources :applications
  get '/apply', to: 'applications#new'
  get '/application', to: 'applications#new'
  post '/application', to: 'applications#create'
  get '/application/edit', to: 'applications#edit'
  put '/application', to: 'applications#update'

  get '/rsvp', to: 'rsvp#new'
  post '/rsvp', to: 'rsvp#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/forgot', to: 'sessions#forgot_password'
  post '/forgot', to: 'sessions#send_password_email'
  get '/logout', to: 'sessions#destroy'
  get '/users/password/reset', to: 'user#reset_password'
  get '/users/password/change', to: 'user#change_password'
  post '/users/password/change', to: 'user#change_password_post'
  post '/users/password/reset', to: 'user#reset_password_post'
  post '/users/account/destroy', to: 'user#destroy'
  root "home#index"

  post '/batch/create', to: 'batch#create'
  post '/batch/destroy', to: 'batch#destroy'
  post '/batch/update', to: 'batch#update'

  resources :faqs



end
