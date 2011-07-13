class Subject < ActiveRecord::Base
  validates_presence_of :code
  
  has_many :statistics
end