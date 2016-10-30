class ApplicationController < ActionController::Base
  include Authentication
  include ApplicationHelper

  # protect_from_forgery unless: -> { request.format.json? }
  skip_before_filter :verify_authenticity_token
end
