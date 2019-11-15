#!/bin/sh
cp $1 .env.production

unset VERSION # unset VERSION to prevent conflicts in db:migrate
bin/rails db:migrate

if [ -f "$2" ]
then
  source .env.production
  PGPASSWORD=$POSTGRES_PASSWORD psql -h $POSTGRES_HOST -U $POSTGRES_USER -d $POSTGRES_DB -1 -f $2
fi

bundle exec puma -C config/puma.rb
