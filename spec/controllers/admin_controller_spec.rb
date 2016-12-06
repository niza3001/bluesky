require 'rails_helper'

RSpec.describe AdminController, type: :controller do

  before(:each) do
    @user1 = FactoryGirl.create(:user, email: "niloofar@example.com")
    @user2 = FactoryGirl.create(:user, email: "zarei@example.com")
    sign_in @user1
  end

  describe "GET#index" do
    it "should render the correct view" do
    get :index
    expect(response).to render_template(:application)
    end
  end

end
