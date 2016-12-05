require 'rails_helper'

RSpec.describe InstructorHelper, type: :helper do
  describe "#course_name_for" do
    it "returns the subject and course number appended" do
      inst = FactoryGirl.create(:instructor)
      FactoryGirl.create(:evaluation, instructor: inst, subject: "CSCE", course: "121")
      expect(helper.course_name_for(inst.course_section_groups[0].first)).to eq("CSCE 121")
    end

    it "appends H to the course name if it is honors" do
      inst = FactoryGirl.create(:instructor)
      FactoryGirl.create(:evaluation, instructor: inst, subject: "CSCE", course: "121", section: 200)
      expect(helper.course_name_for(inst.course_section_groups[0].first)).to eq("CSCE 121H")
    end

    it "#is_honors" do
      expect(is_honors(221)).to eq("H")
      expect(is_honors(121)).to eq("")
    end
  end
end
