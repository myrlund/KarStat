class Statistic < ActiveRecord::Base
  belongs_to :subject
  
  serialize :content
  
  def self.filter_params
    [:year, :semester]
  end
end