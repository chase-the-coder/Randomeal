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
      geocoder = Geocoder.search([params[:latitude].to_f, params[:longitude].to_f])
      @user_address = "#{geocoder.first.data["address"]["house_number"]}, #{geocoder.first.data["address"]["address27"]}"
    end
  end

  def contact
  end

  def about
  end

end
