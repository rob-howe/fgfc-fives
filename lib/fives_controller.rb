require 'sinatra/base'
require 'slim'
require 'model/age_group'
require 'model/fives_team'
require 'model/user'
require 'model/summary'
require 'model/mailing_target'
require 'tilt'
require 'pony'
class SendMailError < StandardError
end

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
    begin
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
    rescue SendMailError => ex
      puts "error registering new team problem sending mail #{ex.message}"
      @send_mail_error = true
      erb :registered
    rescue Exception => ex

    rescue => ex
      puts "error registering new team #{ex.message}"
      erb :register
    end

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

  get '/teams/:team_name' do
    team_description = params[:team_name].gsub(/_/, ' ')
    @age_group = AgeGroup.find_by_description(team_description)
    @fives_teams = FivesTeam.find_all_by_age_group_id_and_paid(@age_group.id, true) unless @age_group.nil?

    erb :team
  end

  get '/pdf/fg5s_application_form' do
    slim :fives_app_form, layout: false
  end


  helpers do
    def discount_applicable
      #todo make work
      true
    end

    def has_errors
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
      begin
        mail_text = @@confirmation_template.render(nil, {:fives_team => fives_team, :age_group => age_group, :discount_applicable => discount_applicable})
        Pony.mail(
            :from => 'forest glade fives' + "<fg5s@forestgladefc.co.uk>",
            :to => fives_team.email_address,
            :subject => "The Forest Glade Fives - Application Confirmation - Your Reference: " + fives_team.ref_id,
            :html_body => mail_text,
            :port => '587',
            :via => :smtp,
            :via_options => {
                :address => 'smtp.gmail.com',
                :port => '587',
                :enable_starttls_auto => true,
                :user_name => 'fg5s@forestgladefc.co.uk',
                :password => 'fives-f0restg!ade',
                :authentication => :plain,
                :domain => 'localhost.localdomain'
            })
      rescue => ex
        raise SendMailError.new (ex.message)
      end
    end

  end

  require_relative 'routes/admin'
  require_relative 'routes/error'
  require_relative 'routes/payment'
  require_relative 'routes/email'
end
