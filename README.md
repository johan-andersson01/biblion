# Requirements

* Ruby >= 2.4
* Rails >= 5.0

# Local setup

` cd /your_path/`

` git clone https://github.com/johan-andersson01/biblion.git`

` cd biblion`

` bundle install `

` rails db:migrate`

` rails db:seed`

` rails s `

After executing these commands, the server will be up and running at localhost:3000.

You will have created one admin user with the `db:seed` command, with the following credentials:

> email: admin@foo.bar

> password: foobar

These can be changed later when logging in in the browser.

# Porting to another language

Since this project has been built for Swedish users in mind, much of the interface is written in Swedish. Here are some tips if you want to port this project to another language & location:

* Go through all files under `/app/views/` and look for Swedish words and sentences.
* Replace all instances of `CS.states(:se)` with your country of choice.
