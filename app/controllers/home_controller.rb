class HomeController < ApplicationController
  def index
    @billers = Rails.cache.fetch("all_billers", expires_in: 1.hour) do
      Biller.all.to_a
    end
  end
end
