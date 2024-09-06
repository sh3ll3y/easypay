class LanguageController < ApplicationController
  def update
    if I18n.available_locales.map(&:to_s).include?(params[:language])
      current_user.update(language: params[:language]) if current_user
      session[:language] = params[:language]
      I18n.locale = params[:language]
    end
    redirect_back(fallback_location: root_path)
  end
end
