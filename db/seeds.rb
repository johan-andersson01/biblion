User.create!(name: "admin",
             email: "admin@foo.bar",
             password:              "foobar9000",
             password_confirmation: "foobar9000",
             admin: true,
             activated: true,
             activated_at: Time.zone.now,
             location: "Admin City",
             landscape: "Admin County ")
User.create!(name:  "tester",
             email: "tester@foo.bar",
             password:              "foobar9000",
             password_confirmation: "foobar9000",
             admin: false,
             activated: true,
             activated_at: Time.zone.now,
             location: "Test City",
             landscape: "Test County ")
