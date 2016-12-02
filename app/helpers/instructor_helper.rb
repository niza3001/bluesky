module InstructorHelper

  def course_name_for(course)

    name = course.subject_course;
    if (course.section.to_s.starts_with?("2"))
      name = name + "H"
    end

    return name
  end

  def get_complete_name(course)
    complete_name = course.subject_course;
    if (course.section.to_s.starts_with?("2"))
      complete_name = complete_name + "H"
    end

    name = CourseName.where(subject_course: course.subject_course).first.try(:name)
    if (!name.nil?)
      complete_name = complete_name + " " + name
    end

    return complete_name
  end

  def is_honors(course_section)
    if (course_section.to_s.starts_with?("2"))
      return "H"
    else
      ""
    end
  end

end
