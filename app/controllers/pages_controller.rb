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
      p "====================================="
      geocoder = Geocoder.search([params[:latitude].to_f, params[:longitude].to_f]).first.data["address"]
      p geocoder
      if geocoder["house_number"].present?
        @user_address = "#{geocoder["house_number"]}, #{geocoder["#{geocoder.keys.first}"]}"
      else
        @user_address = geocoder["#{geocoder.keys.first}"]
      end
    end
  end

  def contact
  end

  def about
  end

end
