class User < ActiveRecord::Base
  has_many :microposts ,dependent: :destroy
  before_save { self.email = email.downcase }
  before_create :create_remember_token


  VALID = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,presence: true,format: {with:VALID},uniqueness: { case_sensitive:false }
  validates :name,presence: true,length: {maximum:50}
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  private 
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
