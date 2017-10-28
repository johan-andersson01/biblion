User.create!(name:  "Johan",
             email: "johan@biblion.se",
             telephone: "000000000",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now,
             location: Faker::HarryPotter.location,
             landscape: Faker::StarWars.planet)

2.times do |n|
  name  = Faker::Name.name.first
  email = "user-#{n+1}@biblion.se"
  password = "password"
  User.create!(name:  name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now,
               location: Faker::HarryPotter.location,
               landscape: Faker::StarWars.planet)
end
#
# users = User.order(:created_at).take(10)
# 60.times do
#   title = Faker::Zelda.character
#   author = Faker::Name.name
#   year = Faker::Date.between(100.years.ago, Date.today)
#   description = Faker::Lorem.sentence(15)
#   swaps = Faker::Number.between(0, 10)
#   available = [true, false].sample
#   cover = Faker::LoremPixel.image("150x224")
#   users.each { |user| user.books.create!(title: title, author: author, year: year,
#     description: description, swaps: swaps, available: available, cover: cover) }
# end
