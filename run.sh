#!/bin/sh
cp $1 .env.production

unset VERSION # unset VERSION to prevent conflicts in db:migrate
bin/rails db:migrate

bundle exec puma -C config/puma.rb
