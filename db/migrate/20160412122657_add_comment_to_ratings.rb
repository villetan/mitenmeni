class AddCommentToRatings < ActiveRecord::Migration
  def change
    execute("ALTER TABLE ratings ADD COLUMN comment varchar(1000)")
  end
end
