FactoryGirl.define do
  factory :user do
    #password_salt1 = BCrypt::Engine.generate_salt
   # password_encrypted1 = BCrypt::Engine.hash_secret("kissa", password_salt)
    username "Pekka"
    password_encrypted "kissa"
    password_salt "kissa"
  end

  factory :rating do
    score 9
    comment "moi"
    place_id "asdffeqasd"
  end


end