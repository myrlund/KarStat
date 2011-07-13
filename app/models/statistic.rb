class Statistic < ActiveRecord::Base
  belongs_to :subject
  
  serialize :content
end