User.create!(name:  "admin",
             email: "admin@foo.bar",
             password:              "foobar9000",
             password_confirmation: "foobar9000",
             admin: true,
             activated: true,
             activated_at: Time.zone.now,
             location: "Admin City",
             landscape: "Admin County ")
