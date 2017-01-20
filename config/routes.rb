# == Route Map
#
#                 Prefix Verb   URI Pattern                       Controller#Action
#             home_index GET    /home(.:format)                   home#index
#                        POST   /home(.:format)                   home#create
#               new_home GET    /home/new(.:format)               home#new
#              edit_home GET    /home/:id/edit(.:format)          home#edit
#                   home GET    /home/:id(.:format)               home#show
#                        PATCH  /home/:id(.:format)               home#update
#                        PUT    /home/:id(.:format)               home#update
#                        DELETE /home/:id(.:format)               home#destroy
#              subscribe POST   /subscribe(.:format)              home#subscribe
#          rememberTheme POST   /rememberTheme(.:format)          home#rememberTheme
#             user_index GET    /user(.:format)                   user#index
#                        POST   /user(.:format)                   user#create
#               new_user GET    /user/new(.:format)               user#new
#              edit_user GET    /user/:id/edit(.:format)          user#edit
#                   user GET    /user/:id(.:format)               user#show
#                        PATCH  /user/:id(.:format)               user#update
#                        PUT    /user/:id(.:format)               user#update
#                        DELETE /user/:id(.:format)               user#destroy
#              dashboard GET    /dashboard(.:format)              user#dashboard
#                  admin GET    /admin(.:format)                  admin#dashboard
#        admin_dashboard GET    /admin/dashboard(.:format)        admin#dashboard
#  admin_dashboard_stats POST   /admin/dashboard/stats(.:format)  admin#dashboard_stats
#              admin_faq GET    /admin/faq(.:format)              admin#faq
#         admin_faq_view GET    /admin/faq/view(.:format)         admin#faq_view
#      admin_sponsorship GET    /admin/sponsorship(.:format)      admin#sponsorship
# admin_sponsorship_view GET    /admin/sponsorship/view(.:format) admin#sponsorship
#                        POST   /admin/sponsorship/view(.:format) admin#sponsorship_view
#       admin_statistics GET    /admin/statistics(.:format)       admin#statistics
#            admin_stats GET    /admin/stats(.:format)            admin#statistics
#             statistics GET    /statistics(.:format)             admin#stats
#                  stats GET    /stats(.:format)                  admin#stats
#           admin_onsite GET    /admin/onsite(.:format)           admin#onsite_registration
#           applications GET    /applications(.:format)           applications#index
#                        POST   /applications(.:format)           applications#create
#        new_application GET    /applications/new(.:format)       applications#new
#       edit_application GET    /applications/:id/edit(.:format)  applications#edit
#            application GET    /applications/:id(.:format)       applications#show
#                        PATCH  /applications/:id(.:format)       applications#update
#                        PUT    /applications/:id(.:format)       applications#update
#                        DELETE /applications/:id(.:format)       applications#destroy
#                  apply GET    /apply(.:format)                  applications#new
#                        GET    /application(.:format)            applications#new
#                        POST   /application(.:format)            applications#create
#       application_edit GET    /application/edit(.:format)       applications#edit
#                        PUT    /application(.:format)            applications#update
#                   rsvp GET    /rsvp(.:format)                   rsvp#new
#                        POST   /rsvp(.:format)                   rsvp#create
#                  login GET    /login(.:format)                  sessions#new
#                        POST   /login(.:format)                  sessions#create
#                 forgot GET    /forgot(.:format)                 sessions#forgot_password
#                        POST   /forgot(.:format)                 sessions#send_password_email
#                 logout GET    /logout(.:format)                 sessions#destroy
#   users_password_reset GET    /users/password/reset(.:format)   user#reset_password
#  users_password_change GET    /users/password/change(.:format)  user#change_password
#                        POST   /users/password/change(.:format)  user#change_password_post
#                        POST   /users/password/reset(.:format)   user#reset_password_post
#  users_account_destroy POST   /users/account/destroy(.:format)  user#destroy
#                   root GET    /                                 home#index
#           batch_create POST   /batch/create(.:format)           batch#create
#          batch_destroy POST   /batch/destroy(.:format)          batch#destroy
#           batch_update POST   /batch/update(.:format)           batch#update
#                   faqs GET    /faqs(.:format)                   faqs#index
#                        POST   /faqs(.:format)                   faqs#create
#                new_faq GET    /faqs/new(.:format)               faqs#new
#               edit_faq GET    /faqs/:id/edit(.:format)          faqs#edit
#                    faq GET    /faqs/:id(.:format)               faqs#show
#                        PATCH  /faqs/:id(.:format)               faqs#update
#                        PUT    /faqs/:id(.:format)               faqs#update
#                        DELETE /faqs/:id(.:format)               faqs#destroy
#

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :home
  post "/subscribe", to: 'home#subscribe'
  post "/rememberTheme", to: 'home#rememberTheme'
  post "/changeSponsors", to: 'home#change_sponsors'

  resources :user
  get '/dashboard', to: 'user#dashboard'

  get '/admin', to: 'admin#dashboard'
  get '/admin/dashboard', to: 'admin#dashboard'
  post '/admin/dashboard/stats', to: 'admin#dashboard_stats'

  get '/admin/faq', to: 'admin#faq'
  get '/admin/faq/view', to: 'admin#faq_view'

  get '/admin/sponsorship', to: 'admin#sponsorship'
  get '/admin/sponsorship/view', to: 'admin#sponsorship'
  post '/admin/sponsorship/view', to: 'admin#sponsorship_view'

  get '/admin/statistics', to: 'admin#statistics'
  get '/admin/stats', to: 'admin#statistics'
  post '/admin/notifications', to: 'admin#notifications'
  get '/statistics', to: 'admin#stats'
  get '/stats', to: 'admin#stats'

  get '/admin/onsite', to: 'admin#onsite_registration'

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

  get '/live', to: 'live#index'
  get '/push', to: 'live#push'
  post '/push/subscribe', to: 'live#subscribe'
  post '/push/unsubscribe', to: 'live#unsubscribe'

  resources :faqs



end
