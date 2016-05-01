FactoryGirl.define do
  factory :user do
    #password_salt1 = BCrypt::Engine.generate_salt
   # password_encrypted1 = BCrypt::Engine.hash_secret("kissa", password_salt)
    username "Pekka"
    password_encrypted "kissa"
    password_salt "kissa"
  end



  factory :user2, class: User do
    username "Lauri"
    password_encrypted "apina"
    password_salt "apina"
  end



  factory :rating do
    score 9
    comment "moi"
    place_id "asdffeqasd"
  end


  factory :rating2, class: Rating do
    score 1
    comment "kakkonen"
    place_id "salapaikka"
  end

end