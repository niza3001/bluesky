require 'csv'

class EvaluationReportExporter
  include ApplicationHelper

  HEADINGS = [
    "Term",
    "Subject",
    "Course",
    "Section",
    "Instructor",
    "Enrollment",
    "Item 1 mean",
    "Item 2 mean",
    "Item 3 mean",
    "Item 4 mean",
    "Item 5 mean",
    "Item 6 mean",
    "Item 7 mean",
    "Item 8 mean",
    "Mean Student Eval Score",
    "Course Level Average"
  ]
  

  

  CSV_data = 
    [
      'term',
      'subject',
      'course',
      "section",
      "instructor.name",
      "enrollment",
      "item1_mean",
      "item2_mean",
      "item3_mean",
      "item4_mean",
      "item5_mean",
      "item6_mean",
      "item7_mean",
      "item8_mean"
    ]
  
   
  
  def initialize(evaluation_groups)
    @groups = evaluation_groups
  end

  def generate(columns)
    
    temp_HEADINGS = Array.new
   # temp_csv = Array.new
   # puts HEADINGS[0..5]
    temp_HEADINGS = HEADINGS[0..5]
   # puts temp_HEADINGS
   # temp_csv = CSV_data[0..5]
    r = 0
    rr = 0
    # Add/remove Item 1..8 on everything
    (1..8).each do |x|
          #puts columns["#{x}"]
          #puts x
         r = r + 1 
           if (columns["#{x}"] == "1" )
             rr = rr + 1
             temp_HEADINGS[5+rr] = HEADINGS[5+r]   #"Item 1 mean"           # HEADINGS
            # temp_csv[5+rr] = CSV_data[5+r]             #item2_mean
          #   puts r
           end 

         end 
         
    temp_HEADINGS = temp_HEADINGS + HEADINGS[14..15]
  #  temp_csv = temp_csv + CSV_data[14..15]
    
   # def my_temp_csv
   #    temp_csv.map(&:to_s)
   #   end
           #   puts temp_csv

    
    CSV.generate do |csv|
      csv << temp_HEADINGS
      @groups.each do |group|
        group.each do |eval|
          csv << eval.csv_data(columns)  # (temp_csv).map(&:to_s) # csv << eval.csv_data
         
        end
        formula_data = []
        5.times { formula_data.push("") }
        formula_data.push(compute_total_enrollment(group))
        (1..8).each do |x|
          #puts columns["#{x}"]
          #puts x
          
           if (columns["#{x}"] == "1" )
             formula_data.push(compute_weighted_average_for_item2(x, group).round(2))
           #else
            # formula_data.push(0)
           end
        end
        formula_data.push(compute_mean_student_eval_score(group).round(2))
        formula_data.push(compute_course_level_average(group, @groups).round(2))
        csv << formula_data
        csv << formula_data.map { |_| "" }
      end
    end
  end
end
