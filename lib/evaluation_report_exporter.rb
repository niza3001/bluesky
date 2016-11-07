require 'csv'

class EvaluationReportExporter
  include ApplicationHelper

  HEADINGS = [
    "Term",
    "Subject",
    "Course",
    "Section",
    "Course Name",
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


  def initialize(evaluation_groups)
    @groups = evaluation_groups
  end

  def generate(itemz)
    temp_HEADINGS = Array.new

    if !itemz.nil?
      temp_HEADINGS = HEADINGS[0..7]

      # Add/remove Item 1..8 on everything
      count = 0
      (1..8).each do |x|
        if itemz.key?(x.to_s)
          temp_HEADINGS[count + 7] = HEADINGS[x + 6]
          count = count + 1
        end
      end

      temp_HEADINGS = temp_HEADINGS + HEADINGS[15..16]
    else
      temp_HEADINGS = HEADINGS
    end

    CSV.generate do |csv|
      csv << temp_HEADINGS
      @groups.each do |group|
        group.each do |eval|
          csv << eval.csv_data(itemz)
        end

        formula_data = []
        6.times { formula_data.push("") }
        formula_data.push(compute_total_enrollment(group))

        if itemz.nil?
          (1..8).each do |x|
            formula_data.push(compute_weighted_average_for_item(x, group).round(2))
          end
        else
          (1..8).each do |x|
            if itemz.key?(x.to_s)
              formula_data.push(compute_weighted_average_for_item2(x, group).round(2))
            end
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
