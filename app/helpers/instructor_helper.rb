module InstructorHelper

  def course_name_for(course)
    #course.subject_course + (course.is_honors_section? ? "H" : "")

     if (course.section.to_s.starts_with?("2"))
      return course.subject_course + "H"
    else
      course.subject_course
    end

  end

  def is_honors(course_section)
    if (course_section.to_s.starts_with?("2"))
      return "H"
    else
      ""
    end
  end

end
