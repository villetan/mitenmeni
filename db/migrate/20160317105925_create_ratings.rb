class CreateRatings < ActiveRecord::Migration
  def change
    execute "CREATE TABLE ratings(
    rating_id serial PRIMARY KEY,
    user_id INT references users(user_id),
    score INT CHECK(score>=0 and score <= 10)
    );"
  end
end

