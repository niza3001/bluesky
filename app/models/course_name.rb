class CourseName < ActiveRecord::Base
  #has_many :evaluations
  has_many :instructor
  validates :subject_course, presence: true, format: { with: /\A[A-Z]{4} \d{3}\z/,
    message: "must be in the form ABCD 123. (e.g. CSCE 121)" }
  validates :name, presence: true

  def self.create_if_needed_and_update(attrs)
    course_name = where(subject_course: attrs[:subject_course]).first_or_initialize

    is_new_record = course_name.new_record?
    course_name.save
    course_name.update(attrs)
    [ course_name, is_new_record ]
  end


end
