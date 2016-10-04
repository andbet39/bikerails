json.extract! meeting, :id, :title, :start_lat, :start_lng, :start_time, :duration, :created_at, :updated_at
json.url meeting_url(meeting, format: :json)