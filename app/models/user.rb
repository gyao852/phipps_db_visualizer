class User < ApplicationRecord
  has_secure_password

  # Relationships
  # -----------------------------
  # no relationships

  # Scopes
  # -----------------------------
  scope :alphabetical, -> { order('lname,fname') }


  # Validations
  # -----------------------------
  validates_presence_of :fname
  validates_presence_of :lname
  validates_presence_of :password, on: :create
  #validates_confirmation_of :password, message: "doesn't match fonrimation"
  validates :email_id, presence: true
  validates :email_id, format: { with:/.+@.+\..+/i, message: "format of email address is incorrect"}
  validates_inclusion_of :active, :in => [true,false]


  # Other methods
  # -------------

  def self.authenticate(login,pass)
    user = find_by_username(login) || find_by_email(login)
    return user if user && user.password_hash == user.encrypt_password(pass)
  end

  def encrypt_password(pass)
    BCrypt::Engine.hash_secret(pass,password_salt)
  end
  

  private
  
  def prepare_password
    unless password.blank?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = encrypt_password(password)
    end
  end

end
