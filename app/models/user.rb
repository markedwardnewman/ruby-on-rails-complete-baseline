class User < ActiveRecord::Base
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
end
