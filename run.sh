#!/bin/sh

# Copyright 2019 Adevinta

set -e

envsubst < .env.config > .env.production

if [ -n "$POSTGRES_CA_B64" ]; then
  mkdir -p /root/.postgresql
  echo "$POSTGRES_CA_B64" | base64 -d > /root/.postgresql/root.crt  # for rails
fi

unset VERSION # unset VERSION to prevent conflicts in db:migrate
bundle exec rake db:migrate

if [ -f "$1" ]
then
  source .env.production
  PGPASSWORD=$POSTGRES_PASSWORD PGSSLMODE=$POSTGRES_SSLMODE psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -1 -f "$1"
fi

exec bundle exec puma -C config/puma.rb
