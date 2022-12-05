json.extract! channel, :id, :number, :name, :logo, :url, :created_at, :updated_at
json.url channel_url(channel, format: :json)
