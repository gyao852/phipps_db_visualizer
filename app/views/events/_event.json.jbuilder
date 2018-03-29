json.extract! event, :id, :event_id, :event_name, :category, :start_date_time, :end_date_time, :created_at, :updated_at
json.url event_url(event, format: :json)
