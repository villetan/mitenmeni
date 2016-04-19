json.array!(@friendships) do |friendship|
  json.extract! friendship, :id, :friend_a_id, :friend_b_id, :status
  json.url friendship_url(friendship, format: :json)
end
