require 'sinatra/base'
require 'model/age_group'
require 'model/fives_team'
require 'model/user'
require 'model/summary'
require 'tilt'
require 'pony'

class FivesController < Sinatra::Base
  @@confirmation_template = Tilt.new("#{File.dirname(__FILE__)}/email_templates/confirmation.erb")

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
    send_confirmation_mail @fives_team, @age_group
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

    def applications_closed
      $closing_date
      false
    end

    def applications_closing
      $closing_date
      false
    end

    def send_confirmation_mail fives_team, age_group

      mail_text = @@confirmation_template.render(nil, {:fives_team => fives_team, :age_group => age_group, :discount_applicable => discount_applicable})
      Pony.mail(
          :from => 'forest glade fives' + "<fg5s@forestgladefc.co.uk>",
          :to => 'robert.howe@gmail.com',
          :subject => "The Forest Glade Fives - Application Confirmation - Your Reference: "  + fives_team.ref_id,
          :body => mail_text,
          :port => '587',
          :via => :smtp,
          :via_options => {
              :address => 'smtp.gmail.com',
              :port => '587',
              :enable_starttls_auto => true,
              :user_name => 'sysadmin@forestgladefc.co.uk',
              :password => 'f0restg!ade',
              :authentication => :plain,
              :domain => 'localhost.localdomain'
          })
    end
  end

  require_relative 'routes/admin'
  require_relative 'routes/error'
  require_relative 'routes/payment'
end
