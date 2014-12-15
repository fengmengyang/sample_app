require 'spec_helper'

describe User do
  before { @user = User.new(name:"Example user",email:"user@example.com") }
  subject {@user}
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should_not be_admin }

  describe "with admin attribute set true" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end
    it { should be_admin }
  end
  describe "when email is present" do
    before { @user.email = "" }
    it { should_not be_valid }
  end
  describe "when name is present" do
    before { @user.name = "" }
    it { should_not be_valid }
  end
  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end
  describe "when email format is invalid " do
    it "should be invalid" do
      addresses =  %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_addr|
        @user.email = invalid_addr
        expect(@user).not_to be_valid
      end
    end
  end
  describe "when email format is valid " do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_addr|
        @user.email = valid_addr
        expect(@user).to be_valid
      end
    end
  end
  describe "when email have taken" do
    before do
      email_user = @user.dup
      email_user.email = @user.email.upcase
      email_user.save
    end
    it { should_not be_valid }
  end
  describe "remember token" do
    before { @user.save }
    it {expect(@user.remember_token).not_to be_blank}
  end


  describe "micropost associations" do
    before { @user.save }
    let!(:old_micropost) { FactoryGirl.create(:micropost,user: @user,created_at: 1.day.ago) }
    let!(:new_micropost) { FactoryGirl.create(:micropost,user: @user,created_at: 1.hour.ago)}
    
    it "should have the microposts in the right order" do
      expect(@user.microposts.to_a).to eq [new_micropost,old_micropost]
    end
    it "user destroy associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.user_id)).to be_empty
      end
    end
    describe "status" do
      let!(:unfollowed) { FactoryGirl.create(:micropost,user: FactoryGirl.create(:user)) }
      its(:feed) { should include(new_micropost) }
      its(:feed) { should include(old_micropost) }
      its(:feed) { should_not include(unfollowed) }
    end
  end
end
