require 'grade_api'
class CoursesController < ApplicationController
  def show
    @code = params[:code].gsub(/[^\w\d]*/, "")
    @stats = GradeAPI.get(@code, params)
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @stats }
      format.json { render :json => @stats }
    end
  end
end
