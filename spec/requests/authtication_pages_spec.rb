require 'spec_helper'

describe "AuthticationPages" do
  subject {page}
  describe "signin page" do
    before { visit signin_path }
    describe "with invalid information" do
      before { click_button "Sign in" }
      it { should have_selector('div.alert.alert-error',text:"Invalid") }
      it { should have_title('sign in') }
       describe "visit another pages" do
         before { click_link "Home" }
         it { should_not have_selector('div.alert.alert-error') }
       end
    end
    describe "with valid information" do
      let(:user) { FactoryGirl.create(User) }
      before do
        fill_in "Name", with: user.name
        fill_in "Email",with: user.email.upcase
        click_button "Sign in"
      end
      it { should have_title(user.name) }
      it { should have_link('Profile',href:user_path(user)) }
      it { should have_link('Sign out',href:signout_path) }
      it { should_not have_link('Sign in',href:signin_path) }
    end
  end
end
