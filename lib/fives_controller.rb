require 'sinatra/base'
require 'model/age_group'
require 'model/fives_team'
require 'model/user'
require 'model/summary'

class FivesController < Sinatra::Base


  get '/' do
    erb :home
  end

  get '/register' do
    @age_groups = AgeGroup.find(:all)
    erb :register
  end

  post '/registered' do
    @fives_team = FivesTeam.create(
        :age_group_id => params[:age_group_id],
        :team_name => params[:team_name],
        :team_designation => params[:team_designation],
        :manager_name => params[:manager_name],
        :mobile_phone => params[:mobile_phone],
        :home_phone => params[:home_phone],
        :email_address => params[:email_address],
        :address_line1 => params[:address_line1],
        :address_line2 => params[:address_line2],
        :address_town => params[:address_town],
        :address_county => params[:address_county],
        :address_postcode => params[:address_postcode],
        :date_registered => Time.now
    )
    @age_group = AgeGroup.find(params[:age_group_id].to_i)
    erb :registered
  end

  get '/age_groups' do
    @age_groups = AgeGroup.find(:all)
    erb :age_groups
  end


  get '/contacts' do
    erb :contacts
  end

  get '/rules' do
    erb :rules
  end

  get '/referees' do
    erb :referees
  end

  get '/sponsorship' do
    erb :sponsorship
  end

  get '/location' do
    erb :location
  end

  get '/team/:team_name' do
    params[:team_name]
    @age_group = AgeGroup.find_by_description(params[:team_name])
    @fives_teams = FivesTeam.find_all_by_age_group_id_and_paid(@age_group.id, false) unless @age_group.nil?

    erb :team
  end

  helpers do
    def discount_applicable
      true
    end

    def has_errors
      false
    end

    def exhibition_team
      false
    end
  end

 require_relative 'routes/admin'
 require_relative 'routes/error'
 require_relative 'routes/payment'
end
