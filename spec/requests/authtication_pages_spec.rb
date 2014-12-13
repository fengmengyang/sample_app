require 'spec_helper'

describe "AuthticationPages" do
  subject {page}
  describe "signin page" do
    before { visit signin_path }
    describe "with invalid information" do
      before { click_button "Sign in" }
      it { should have_selector('div.alert.alert-error',text:"Invalid") }
      it { should have_title('Sign in') }
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
      it { should have_link('Users',href:users_path) }
      it { should have_link('Profile',href:user_path(user)) }
      it { should have_link('Settings',href:edit_user_path(user)) }
      it { should have_link('Sign out',href:signout_path) }
      it { should_not have_link('Sign in',href:signin_path) }
    end
  end

  describe "authorization" do
    describe "for no-sign-in-user" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Name",with: user.name
          fill_in "Email",with: user.email
          click_button "Sign in"
        end
        describe "after sign in" do
          it "should render expect protected page" do
            expect(page).to have_title("Edit user")
          end
        end

      end
      describe "in the users controler" do
        before { visit edit_user_path(user) }
        it { should have_link("Sign in",href: signin_path) }
        describe "visitting the user index" do
          before { visit users_path }
          it { should have_title("Sign in") }
        end
      end

      describe "submitting to the update or edit action" do
        before { patch user_path(user) }
        it { expect(response).to redirect_to(signin_path) }
      end
      describe "as a non admin user" do
        let(:user) { FactoryGirl.create(:user) }
        let(:non_admin) { FactoryGirl.create(:user) }
        before { sign_in non_admin,no_capybara: true }
        describe "submitting a DELETE request to Users,destroy action" do
          before { delete user_path(user) }
          it { expect(response).to redirect_to(root_path) }
        end
      end
    end
  end


  describe "as a wrong user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:wrong_user) { FactoryGirl.create(:user,email:"wrong@example.com") }
    before { sign_in user,no_capybara:true }
    describe "submitting a GET request to User,Edit action" do
      before { get edit_user_path(wrong_user) }
      it { expect(response.body).not_to match(full_title("Edit user")) }
      it { expect(response).to redirect_to(root_url) }
    end
    describe "submitting a PATCH request to User,Update action" do
      before { patch user_path(wrong_user) }
      it { expect(response).to redirect_to(root_path) }
    end


  end
end
