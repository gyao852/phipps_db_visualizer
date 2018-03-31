class User < ApplicationRecord
  # Relationships
  # -----------------------------
  # no relationships

  # Scopes
  # -----------------------------
  scope :alphabetical, -> { order('lname,fname') }


  # Validations
  # -----------------------------
  validates: user_id, presence :true
  validates: fname, presence :true
  validates: lname, presence :true
  validates: email_id, presence :true
  validates :email_id, format: { with:/\A[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}[\w\-]{2,4}?\z/i , message: "format of email address is incorrect"}
  validates: active, presence :true


  # Other methods
  # -------------

end
