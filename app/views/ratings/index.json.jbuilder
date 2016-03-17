json.array!(@ratings) do |rating|
  json.extract! rating, :id, :score, :user_id
  json.url rating_url(rating, format: :json)
end
