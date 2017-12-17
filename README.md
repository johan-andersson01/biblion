# Biblion.se

## Getting started

### Prerequisites

To run this locally, you need [Ruby](https://www.ruby-lang.org/en/https://www.ruby-lang.org/en/) and [Rails](http://rubyonrails.org/) installed. Biblion has been developed with Ruby 2.4 and Rails 5.0.6. Compatibility with other versions is not guaranteed.

### Installing

Clone this repository into your preferred folder.

` cd /your_path/`

` git clone https://github.com/johan-andersson01/biblion.git`

` cd biblion`

Install gems.

` bundle install`

Create the database.

` rails db:create`

` rails db:migrate`

` rails db:seed`

Run the server.

` rails s `

After executing these commands, the server will be up and running at localhost:3000.

You will have created one admin user and one regular user with the `db:seed` command, with the following credentials:

Admin:

> email: admin@foo.bar

> password: foobar9000

Regular user:

> email: tester@foo.bar

> password: foobar9000

These can be changed later on site, after you've logged in.

## Deployment

This can be easily deployed on Heroku for free. If you're interested in this, see [Michael Hartl's Rails Tutorial](https://www.railstutorial.org/book/beginning).

## Porting to another language

Since this project has been built for Swedish users in mind, much of the interface is written in Swedish. Here are some tips if you want to port this project to another language & location:

* Go through all files under `/app/views/` and look for Swedish words and sentences.
* Replace all instances of `CS.states(:se)` with your country of choice.

## License

You may use this software for whatever you wish as long as you comply with the licenses of the third party libraries in use.

## Acknowledgements

This project would not have been possible without the writings of Michael Hartl: [Ruby on Rails Tutorial](https://www.railstutorial.org).
