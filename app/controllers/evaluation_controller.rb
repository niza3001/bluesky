class EvaluationController < ApplicationController

  before_action :authenticate_user!

  def new
    if can? :write, :all
      @evaluation = Evaluation.new
      # pluck call must remain :name, :id to have the correct ordering for the select box helper
      @instructors = Instructor.select_menu_options
      render layout: "layouts/centered_form"
    else
      redirect_to evaluation_index_path
    end
  end

  def create
    key_attrs, other_attrs = split_attributes(evaluation_params)

    @evaluation = Evaluation.where(key_attrs).first_or_initialize
    @evaluation.assign_attributes(other_attrs)
    @evaluation.save

    if @evaluation.errors.empty?
      flash[:notice] = "Evaluation created."
      redirect_to evaluation_index_path(term: @evaluation.term)
    else
      flash[:errors] = @evaluation.errors
      @instructors = Instructor.select_menu_options
      render 'new', layout: "layouts/centered_form"
    end
  end

  def index
    if can? :read, :all

      selected_instructor = params[:instructor];
      selected_course = params[:course_name];
      selected_year = params[:year];
      selected_semester = params[:semester];

      if selected_year.nil? || selected_semester.nil?
        yr_smstr = Evaluation.no_missing_data.pluck(:term).uniq.sort.reverse.first
      else
        yr_smstr = selected_year+selected_semester
      end

      if yr_smstr.nil?
        flash[:notice] = "No evaluation data exists yet! Try importing some."
        redirect_to root_path
      else
        redirect_to evaluation_path(id: yr_smstr, year: selected_year, semester: selected_semester, instructor_name: selected_instructor, course_name: selected_course)
      end
    else
      redirect_to root_path
    end
  end

  def build_eval_groups
    @terms = Evaluation.pluck(:term).uniq.sort.reverse
    @instructor_names = Instructor.pluck(:name).uniq.sort

    @course_names = []
    @course_temp = Evaluation.pluck(:subject, :course).uniq.sort
    @course_temp.each do |sub, num|
      course_entry = CourseName.where(subject_course: sub + " " + num.to_s)

      name = course_entry.blank? ? "" : " " + course_entry.first.name

      @course_names << sub + " " + num.to_s + name
    end

    @semesters = ["A", "B", "C"]
    @years = []
    @terms.each do |e|
      @years << e.clone.chop
    end

    @years = @years.uniq.sort.reverse

    year = params[:year]
    semester = params[:semester]
    instructor_name = params[:instructor_name]
    course_name = params[:course_name]

    @evaluation_groups = []

    if course_name.nil? || course_name == "All"
      subj = Evaluation.pluck(:subject).uniq.sort
      course = Evaluation.pluck(:course).uniq.sort
    else
      subj_course = course_name.gsub(/\s+/m, ' ').strip.split(" ")
      subj = subj_course[0]
      course = subj_course[1]
    end

    if instructor_name.nil? || instructor_name == "All"
      instructor_id = Evaluation.pluck(:instructor_id)
    else
      instructor_id =
        Instructor.where(name: Instructor.normalize_name(instructor_name)).first.id
    end

    yr = []
    if year.nil? || year == "All"
      yr += @years
    else
      yr << year
    end

    smstr = []
    if semester.nil? || semester == "All"
      smstr += @semesters
    else
      smstr << semester
    end

    if params[:honors].nil? or params[:honors] == "yes"
      honors_query = ""
    elsif params[:honors] == "no"
      honors_query = " AND NOT section LIKE '2%'"
    elsif params[:honors] == "only"
      honors_query = " AND section LIKE '2%'"
    end

    if params[:level].nil?
      level_query = ""
    elsif params[:level] == "u"
      level_query = " AND course NOT LIKE '6%'"
    else
      level_query = " AND course LIKE '" + params[:level] + "%'"
    end

    query_append = honors_query + level_query

    if params[:sort_by].to_s == 'semester_'
      @evaluation_groups += Evaluation.no_missing_data.where(
        "subject IN (?) AND course IN (?) AND instructor_id IN (?)" + query_append, subj, course, instructor_id).semester_sorted_groups
    elsif params[:sort_by].to_s == 'course_'
      @evaluation_groups += Evaluation.no_missing_data.where(
        "subject IN (?) AND course IN (?) AND instructor_id IN (?)" + query_append, subj, course, instructor_id).course_sorted_groups
    elsif params[:sort_by].to_s == 'instructor_'
      @evaluation_groups += Evaluation.no_missing_data.where(
        "subject IN (?) AND course IN (?) AND instructor_id IN (?)" + query_append, subj, course, instructor_id).instructor_sorted_groups
    elsif params[:sort_by].to_s == 'course_level'
      @evaluation_groups += Evaluation.no_missing_data.where(
        "subject IN (?) AND course IN (?) AND instructor_id IN (?)" + query_append, subj, course, instructor_id).level_sorted_groups
    else
      for y in yr
        for s in smstr
          @evaluation_groups += Evaluation.no_missing_data.where(
            "term IN (?) AND subject IN (?) AND course IN (?) AND instructor_id IN (?)" + query_append, y+s, subj, course, instructor_id).default_sorted_groups
        end
      end
    end

    return @evaluation_groups
  end

  def show
    if can? :read, :all
      @evaluation_groups = build_eval_groups()
    else # no read rights
      redirect_to root_path
    end
  end

  def missing_data
    if can? :read, :all
      if params[:sort_by].to_s == 'year'
        @evaluation_groups = Evaluation.missing_data.semester_sorted_groups
      elsif params[:sort_by].to_s == 'course'
        @evaluation_groups = Evaluation.missing_data.course_sorted_groups
      else
        @evaluation_groups = Evaluation.missing_data.semester_sorted_groups
      end
    else
      redirect_to root_path
    end
  end

  def import
    if can? :write, :all
      render layout: "layouts/centered_form"
    else
      redirect_to evaluation_index_path
    end
  end

  def import_gpr
    if can? :write, :all
      render layout: "layouts/centered_form"
    else
      redirect_to evaluation_index_path
    end
  end

  def export
    if can? :read, :all
      @evaluation_groups = build_eval_groups()
      send_data EvaluationReportExporter.new(@evaluation_groups).generate, filename: "evaluation_report_#{Time.now.strftime('%F')}.csv"
    end
  end

  def edit
    @evaluation = Evaluation.find(evaluation_id)
    @instructors = Instructor.select_menu_options
    render layout: "layouts/centered_form"
  end

  def destroy
    @evaluation = Evaluation.find(evaluation_id)
    key_string = @evaluation.key.values.map(&:to_s).join("-")
    @evaluation.destroy
    flash[:notice] = "The evaluation for #{key_string} has been deleted."
    redirect_to evaluation_index_path
  end

  def update
    @evaluation = Evaluation.find(evaluation_id)
    @evaluation, _ = Evaluation.create_if_needed_and_update(@evaluation.key, evaluation_params)
    if @evaluation.errors.empty?
      flash[:notice] = "Evaluation updated."
      redirect_to evaluation_path(id: @evaluation.term)
    else
      flash[:errors] = @evaluation.errors
      @instructors = Instructor.select_menu_options
      render 'edit'
    end
  end

  def upload
    if params[:data_file] != nil
      file = params[:data_file]
      filename = file.original_filename
      importer = ::PicaReportImporter.new(params.require(:data_file).tempfile, filename)
      importer.import
      results = importer.results

      flash[:notice] = "#{results[:created]} new evaluations imported. #{results[:updated]} evaluations updated. #{results[:failed]} evaluations were not imported."
      redirect_to evaluation_index_path
    else
      flash[:errors] = "File not attached, please select file to upload"
      redirect_to import_evaluation_index_path
    end
  rescue ::PicaReportImporter::MalformedFileException => ex
    flash[:errors] = ex.to_s
    redirect_to import_evaluation_index_path
  rescue
    flash[:errors] = "There was an error parsing your Excel file. Maybe it is corrupt?"
    redirect_to import_evaluation_index_path
  end

  def upload_gpr
    unless params[:term] && params[:term].match(/\A[12][0-9]{3}[A-Z]\z/)
      flash[:errors] = "Term is either missing or in the incorrect format."
      redirect_to import_gpr_evaluation_index_path
      return
    end

    if params[:data_file].nil?
      flash[:errors] = "File not attached, please select file to upload"
      redirect_to import_gpr_evaluation_index_path
      return
    end

    importer = ::GradeDistributionReportImporter.new(params.require(:data_file).tempfile, params[:term])
    importer.import
    results = importer.results

    flash[:notice] = "#{results[:created]} new GPRs imported. #{results[:updated]} evaluation GPRs updated. #{results[:failed]} evaluation GPRs were not imported."
    redirect_to evaluation_index_path
  rescue PDF::Reader::MalformedPDFError => ex
    flash[:errors] = "There was an error parsing that PDF file. Maybe it is corrupt?"
    redirect_to import_gpr_evaluation_index_path
  end

  private
  def split_attributes(all_attrs)
    # key attributes are ones for which we should have one unique record for a
    # set of them
    key_attributes = all_attrs.select { |k,v| Evaluation.key_attributes.include?(k.to_sym) }

    # other atttributes are ones that should either be assigned or updated
    other_attributes = all_attrs.reject { |k,v| Evaluation.key_attributes.include?(k.to_sym) }
    if other_attributes[:instructor] && !other_attributes[:instructor].instance_of?(Instructor) && !other_attributes[:instructor].empty?
      other_attributes[:instructor] = Instructor.where(name: Instructor.normalize_name(other_attributes[:instructor])).first_or_create
    elsif other_attributes[:instructor_id] && other_attributes[:instructor_id] != "0"
      other_attributes[:instructor] = Instructor.where(id: other_attributes[:instructor_id]).first
      other_attributes.delete(:instructor_id)
    end

    [ key_attributes, other_attributes ]
  end

  def evaluation_params
    params.require(:evaluation).permit(:term, :subject, :course, :section, :instructor_id,
                                       :enrollment, :item1_mean, :item2_mean, :item3_mean, :item4_mean, :item5_mean,
                                       :item6_mean, :item7_mean, :item8_mean, :Itemz, :instructor,:course_name, :gpr).to_h.symbolize_keys!
  end

  def evaluation_id
    params.require(:id)
  end
end
