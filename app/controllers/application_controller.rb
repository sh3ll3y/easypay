class ApplicationController < ActionController::Base
  before_action :set_locale
  
  private
  
  def set_locale
    I18n.locale = current_user&.language || session[:language] || I18n.default_locale
  end
end
