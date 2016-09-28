json.extract! point, :id, :lat, :lng, :elevation, :time, :created_at, :updated_at
json.url point_url(point, format: :json)