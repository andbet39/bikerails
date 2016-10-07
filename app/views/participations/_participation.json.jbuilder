json.extract! participation, :id, :created_at, :updated_at , :user , :meeting
json.url participation_url(participation, format: :json)