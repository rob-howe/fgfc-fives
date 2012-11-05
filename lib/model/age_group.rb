require 'active_record'
class AgeGroup < ActiveRecord::Base
  #attr_accessor :description , :day

  self.table_name = "age_group"

  has_many :fives_teams
end