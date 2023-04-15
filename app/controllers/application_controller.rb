class ApplicationController < ActionController::Base
  include LocalesHelper

  protect_from_forgery with: :exception
end
