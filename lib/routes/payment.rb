require "sinatra/base"

class FivesController < Sinatra::Base

  get '/confirmed' do
    String ref_id = params[:refId]

    if (ref_id)
      id = ref_id[-3..-1]
      fives_team = FivesTeam.find_by_id(:id => id)
      if (fives_team)
        fives_team.paid = true
        fives_team.paypal = true
        begin
          fives_team.update
        rescue
          puts "failed to SAVE CONFIRMED id #{ref_id} as paid by paypal in the database"
        end
      else
        puts "failed to FIND id #{ref_id} when attempting to confirm as paid by paypal"
      end
    else
      puts "refId NOT passed to confirm payment by PAYPAL"
    end
    erb:'payment/confirmed'
  end

  get '/cancelled' do
     erb:'payment/cancelled'
  end

end