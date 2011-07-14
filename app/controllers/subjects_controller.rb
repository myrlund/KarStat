require 'grade_api'
class SubjectsController < ApplicationController
  def show
    # Clean the @code: I don't want to let people hack the NTNU servers using my credentials
    @code = params[:code].gsub(/[^\w\d]*/, "")
    @subject = Subject.find_or_create_by_code(@code)
    
    # Filter by passed parameters
    @filter_params = {}
    Statistic.filter_params.each do |param|
      @filter_params[param] = params[param] if params.has_key?(param)
    end
    
    statistics = @subject.statistics.where(@filter_params)
    if statistics.empty?
      @statistic = Statistic.new(:subject => @subject)
      @statistic.attributes = @filter_params
    else
      @statistic = statistics.first
    end
    
    # Check DB cache
    if params.has_key?(:force) or @statistic.content.nil?
      stats = GradeAPI.get(@code, @filter_params)
      
      # Cache in DB
      @statistic.content = stats
      @statistic.save
    end
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @statistic }
      format.json { render :json => @statistic }
    end
  end
end
