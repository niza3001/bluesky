module InstructorHelper
  def course_name_for(course)
    course.subject_course + (course.is_honors_section? ? "H" : "")
  end
end
