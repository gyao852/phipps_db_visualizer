json.extract! user, :id, :user_id, :fname, :lname, :email_id, :password_digest, :active, :created_at, :updated_at
json.url user_url(user, format: :json)
