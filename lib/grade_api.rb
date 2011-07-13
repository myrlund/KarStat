# coding: utf-8

require 'nokogiri'
require 'mechanize'
require 'logger'

module GradeAPI

  @@login_uri = "https://innsida.ntnu.no/sso/?target=KarstatProd"
  @@report_path = "/karstat/makeReport.do"
  @@report_uri = "http://www.ntnu.no#{@@report_path}"
  
  @@agent = Mechanize.new
  
  @@lang_map = [
    :candidates,
    :at_exam,
    :passed,
    :failed,
    :cancelled,
    :fail_ratio,
    :grade_average,
    :with_sick_note,
    :fail_before_exam,
  ]
  
  def self.config
    @@config ||= {}
  end
  
  def self.config=(hash)
    @@config = hash
  end
  
  def self.configure
    yield config
  end
  
  def self.login
    @@agent.auth(ENV['KARSTAT_USERNAME'], ENV['KARSTAT_PASSWORD'])
    @@agent.get(@@login_uri)
  end

  class << self
    
    def get(code, options={})
      html_doc = Nokogiri::HTML(raw(code))
      tables = html_doc.css(".questTop")
    
      if tables.length == 2
        meta, grades = tables
      
        stats = {
          :meta => handle_meta(meta),
          :grades => handle_grades(grades)
        }
        stats[:grades][:f] = stats[:meta][:failed][:total]
      
        stats
      end
    end
  
    protected
  
      def handle_meta(meta_doc)
        rows = meta_doc.css("tr.tableRow")
    
        meta = {}
    
        i = 0
        rows.each do |row|
          cols = row.css("td")
          if cols.length == 4
            field, total, women, men = cols
            index = field.text.strip.sub(/:$/, "")
        
            meta[@@lang_map[i]] = {
              :total => total.text.strip.to_i,
              :women => women.text.strip.to_i,
              :men => men.text.strip.to_i,
            }
          end
      
          i += 1
        end
    
        meta
      end
  
      def handle_grades(grades_doc)
        rows = grades_doc.css(".tableRow")
    
        grades = {}
    
        rows.each do |row|
          grade, total, women = row.css("td")
          grades[grade.text.strip.downcase.to_sym] = total.text.strip.to_i
        end
    
        grades
      end
    
      def raw(code)
        login
        report_page = @@agent.post(@@report_uri)
        form = report_page.form_with(:action => @@report_path)
        form['courseName'] = code
        result = form.submit

        result.body
      end
    
  end
    
end
