# Stockr: Stock market application

- $ cd stockr
- $ bundle install
- $ bundle exec rake db:migrate
- $ bundle exec rake test
- $ rake db:seed

Before running server, type
$ bin/rake db:migrate RAILS_ENV=development

If db:migrate SQLException, delete db folder and recheckout project.
