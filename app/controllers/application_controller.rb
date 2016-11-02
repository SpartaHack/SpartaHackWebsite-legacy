class ApplicationController < ActionController::Base
  include Authentication
  include ApplicationHelper

  protect_from_forgery unless: -> { request.format.json? }
end
