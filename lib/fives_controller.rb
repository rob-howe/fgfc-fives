require 'sinatra/base'


class FivesController < Sinatra::Base

  get '/' do
     erb:home
  end

  get '/register' do
    @age_groups =[]
    erb:register
  end

  post 'register' do

    erb:registered
  end

  get '/contacts' do
    erb:contacts
  end

  get '/rules' do
    erb:rules
  end

  get '/referees' do
    erb:referees
  end

  get '/sponsorship' do
    erb:sponsorship
  end

  get '/location' do
    erb:location
  end

  get '/team/:team_name' do
     params[:team_name]
    erb:team
  end

 helpers do
   def discount_applicable
     true
   end

   def has_errors
     false
   end
 end


end
