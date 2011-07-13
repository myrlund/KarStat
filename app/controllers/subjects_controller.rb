require 'grade_api'
class SubjectsController < ApplicationController
  def show
    @code = params[:code].gsub(/[^\w\d]*/, "")
    @subject = Subject.find_or_create_by_code(@code)
    
    unless @subject.statistics.empty?
      @stats = @subject.statistics.first.content
    else
      @stats = GradeAPI.get(@code, params)
      Statistic.create!(:subject => @subject, :content => @stats)
    end
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @stats }
      format.json { render :json => @stats }
    end
  end
end
