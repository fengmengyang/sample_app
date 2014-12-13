require 'spec_helper'

describe "UserPages" do
  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      FactoryGirl.create(:user,name:"yang1",email:"yang1@example.com")
      FactoryGirl.create(:user,name:"yang2",email:"yang2@example.com")
      visit users_path
    end
    it { should have_content("All users") }
    it { should have_title("All users") }
    describe "paginate" do
      before(:all) { 30.times { FactoryGirl.create(:user) }}
      after(:all) { User.delete_all }
      it { should have_selector('div.pagination') }
      it "should show users of a page" do
        User.paginate(page:1).each do |user|
          expect(page).to have_selector('li',text: user.name) 
        end
      end
    end
    describe "delete links" do
      it { should_not have_link('delete') }
      describe "as a admin" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end
        it { should have_link("delete",href: user_path(User.first)) }
        it "should be able delete another user" do
          expect do
            click_link('delete',match: :first)
          end.to change(User,:count).by(-1)
        end
        it { should_not have_link("delete",href: user_path(admin)) }
      end
    end
  end
  describe "profile" do
    let(:user) {FactoryGirl.create(:user)}
    before { visit user_path(user) }
    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end
  describe "signup page" do
    before { visit signup_path}
    it {should have_content('Sign up')}
    it {should have_title(full_title('Sign up'))}
  end
  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create my account" }
    describe "with invalid information" do
      it "should not create account" do
        expect {click_button submit}.not_to change(User,:count)
      end
    end
    describe "with valid information" do
      before do
        fill_in "Name",with: "yang"
        fill_in "Email",with: "yang@example.com"
      end
      it "should create account" do
        expect {click_button submit}.to change(User,:count).by(1)
      end
    end
  end
  describe "edit" do
    let(:user) {FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end
    
    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change',href:'http://gravatar.com/emails') }
    end

    describe "with valid information" do
      let(:new_name) { "new_name" }
      let(:new_email) { "new_email@example.com" }
      before do
        fill_in "Name",with: new_name
        fill_in "Email",with: new_email
        click_button "Save changes"
      end
      it { should have_title(new_name) }
      it { should have_link("Sign out",href:signout_path) }
      it { should have_selector('div.alert.alert-success') }
      it { expect(user.reload.name).to eq new_name }
      it { expect(user.reload.email).to eq new_email }
    end

    describe "with invalid information" do
      before do
        fill_in "Name",with: "yang"
        fill_in "Email",with: "yang@example.com."
        click_button "Save changes"
      end
      it { should have_content('error') }
    end
  end
end
