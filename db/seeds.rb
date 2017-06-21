User.create!(name:  "Johan Andersson",
             email: "johan@biblion.se",
             telephone: "000000000",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "user-#{n+1}@biblion.se"
  telephone = "0000000#{n+1}"
  password = "password"
  User.create!(name:  name,
               email: email,
               telephone: telephone,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end
