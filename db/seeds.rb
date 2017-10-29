User.create!(name:  "admin",
             email: "admin@foo.bar",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now,
             location: "Admin City",
             landscape: "Admin County ")
