json.extract! constituent_event, :id, :lookup_id, :event_id, :status, :attend, :host_name, :created_at, :updated_at
json.url constituent_event_url(constituent_event, format: :json)
