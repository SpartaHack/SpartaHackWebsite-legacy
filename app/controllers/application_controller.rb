class ApplicationController < ActionController::Base
  include Authentication
  protect_from_forgery unless: -> { request.format.json? }
end
