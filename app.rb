# # frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/activerecord'

require_relative 'lib/booking'
require_relative 'lib/property'
require_relative 'lib/user'

class MakersBnB < Sinatra::Base
  enable :sessions
  configure :development do
    register Sinatra::Reloader
  end

  get '/log_in' do
    return erb(:log_in)
  end

  get "/bookings" do
    @bookings = Booking.where(user_id: session[:user_id])
    @properties = []
    @bookings.each do |booking|
      @properties << Property.find(booking.property_id)
    end
    erb(:bookings)
  end

  post '/log_in' do
    email = params[:email]
    password = params[:password]

    user = User.find_by(email: email)
    if user.authenticate(password)
      session[:user_id] = user.id
      @bookings = Booking.where(user_id: user.id)
      @properties = []
      @bookings.each do |booking|
        @properties << Property.find(booking.property_id)
      end
      erb(:bookings)
    else
      return erb(:log_in_error)
    end
  end
end
