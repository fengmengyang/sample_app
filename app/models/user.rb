class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  VALID = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,presence: true,format: {with:VALID},uniqueness: { case_sensitive:false }
  validates :name,presence: true,length: {maximum:50}
end
