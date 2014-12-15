require 'spec_helper'

describe "MicropostPages" do
  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost create" do
    before { visit root_path }

    describe "with invalid information" do
      it "should not create a micropost" do
        expect do
          click_button "Post"
        end.not_to change(Micropost,:count)
      end
      describe "error messages" do
        before { click_button "Post" }
        it { should have_content("error") }
      end
    end
    describe "with valid information" do
      before do
        fill_in "micropost_content",with: "Lorem"
      end
      it "should create a micropost" do
        expect do
          click_button "Post"
        end.to change(Micropost,:count).by(1)
      end
    end
  end
  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost,user: user) }
    describe "as a correct user" do
      before { visit root_path }
      it "should delete a micropost" do
        expect do
          click_link "delete"
        end.to change(Micropost,:count).by(-1)
      end
    end
  end
end
