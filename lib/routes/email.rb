require "sinatra/base"

class FivesController < Sinatra::Base

  get '/email' do
    @email_address = params[:email_address]
    if @email_address
      begin
        email_target = MailingTarget.find_by_email_address(@email_address)
        if email_target
          email_target.opted_out = true
          email_target.save
        else
          @email_not_found = true
        end
      rescue => ex
        @email_save_error = true
        puts "Error saving email opt out email:#{@email_address} error was #{ex.message}"
      end
    end
    erb :email_opt_out
  end

end

