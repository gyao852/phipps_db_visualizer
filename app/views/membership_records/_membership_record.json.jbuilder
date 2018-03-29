json.extract! membership_record, :id, :membership_id, :membership_scheme, :membership_level, :add_ons, :membership_level_type, :membership_status, :membership_term, :start_date, :end_date, :last_renewed, :created_at, :updated_at
json.url membership_record_url(membership_record, format: :json)
