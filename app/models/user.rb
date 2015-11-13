class User < ActiveRecord::Base
  attr_accessor :remember_token
  
  # attribute: name
  validates :name, presence: true          #<- ensure that the User.name field is not blank
  validates :name, length: { maximum: 50 } #<- ensure that the User.name length is < 51
  
  # attribute: email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_save { self.email = email.downcase } #<- downcases user supplied email addresses before saving to the database
  validates :email, presence: true, length: { maximum: 255 }
  validates :email, format: { with: VALID_EMAIL_REGEX }
  validates :email, uniqueness: { case_sensitive: false }
  
  # attribude: password
  validates :password, presence: true
  validates :password, length: { minimum: 6 }
  
  # has_secure_password adds the following functionality:
    # the ability to save a securely hashed password_digest (a hashed password) attribute to the database
    # a pair of virtual attributes (password and password_confirmation), including presence validations upon object creation and a validation requiring that they match
    # an authenticate method that returns the user when the password is correct (and false otherwise)
  has_secure_password
  
  # Returns the hash digest of the given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # Returns a random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # Remembers a user in the database for use in persistent sessions
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # Returns true if the given token matches the digest
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # Forgets a user
  def forget
    update_attribute(:remember_digest, nil)
  end
end
