class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    session[:category] = nil
    session[:price] = nil
    session[:lat] = nil
    session[:long] = nil
    session[:distance] = nil
    session[:sidekiq_job_id] = nil

    if params[:latitude] && params[:longitude]
      @user_address = Geocoder.search([params[:latitude], params[:longitude]]).first.data["address"]["road"]
    end
  end

  def contact
  end

  def about
  end

end
