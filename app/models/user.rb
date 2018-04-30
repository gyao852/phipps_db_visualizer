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
  

  scope :active, ->  {where(active: true)}
  scope :inactive, -> {where(active: false)}

  # Other methods
  # -------------


  private


end
