require 'spec_helper'
describe "Static pages" do
  let(:base_title) {"Ruby on Rails Tutorial Sample App"}
  subject{page}
  describe "Home page" do
    before{visit root_path}
    it {should have_content('Sample App')}
    it {should have_title(full_title('Home'))}
  end
  describe "Help page" do
    before {visit help_path}
    it {should have_content('Help')}
    it {should have_title(full_title('Help'))}
  end
  describe "About page" do
    before {visit about_path}
    it {should have_content('About Us')}
    it {should have_title(full_title('About Us'))} 
  end
  describe "Contact page"
    before {visit contact_path}
    it {should have_content('Contact')}
    it {should have_title(full_title('Contact'))}
  end
  describe "for signed-in users" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      FactoryGirl.create(:micropost,user: user,content: "Lorem ipsum")
      FactoryGirl.create(:micropost,user: user,content: "Feng Meng Yang")
      sign_in user
      visit root_path
    end
    it "should render the user's feed" do
      user.feed.each do |feed|
        expect(page).to have_selector("li##{feed.id}",text: feed.content)
      end
    end
    describe "follower/following count" do
      let(:other_user) { FactoryGirl.create(:user) }
      before do
        other_user.follow!(user)
        visit root_path
      end
      it {expect(page).to have_link("0 following", href: following_user_path(user)) }
      it {expect(page).to have_link("1 followers", href: followers_user_path(user)) }
    end
    describe "click link signout" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in user
        click_link 'Sign out'
      end
      it { expect(page).to have_title(full_title("Home")) }
    end
  end


