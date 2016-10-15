class CourseName < ActiveRecord::Base
  validates :subject_course, presence: true, format: { with: /\A[A-Z]{4} \d{3}\z/,
    message: "must be in the form ABCD 123. (e.g. CSCE 121)" }
  validates :name, presence: true
end
