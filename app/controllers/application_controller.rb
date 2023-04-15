class ApplicationController < ActionController::Base
  include LocalesHelper

  protect_from_forgery with: :exception

  before_action :set_language

  def set_language
    I18n.locale = 'es-PE'
  end
end
