require 'grade_api'

GradeAPI.configure do |config|
  config[:username] = ENV['KARSTAT_USERNAME']
  config[:password] = ENV['KARSTAT_PASSWORD']
end
