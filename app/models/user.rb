require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :email, :password
  
  validates :email, :password_digest, presence: true
  validates :email, uniqueness: true
  
  has_many :board_assignments
  has_many :boards, through: :board_assignments
  
  def password=(input)
    self.password_digest = BCrypt::Password.create(input)
  end
  
  def verify_password(input)
    BCrypt::Password.new(self.password_digest) == input
  end
  
  def reset_session_token!
    self.session_token = SecureRandom::base64(32)
    self.save!
    
    self.session_token
  end
  
end