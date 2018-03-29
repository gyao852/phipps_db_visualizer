json.extract! donation_history, :id, :donation_history_id, :lookup_id, :amount, :date, :method, :do_not_acknowledge, :given_anonymously, :transaction_type, :created_at, :updated_at
json.url donation_history_url(donation_history, format: :json)
