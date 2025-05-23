# Vulcan Persistence

## Developing

In order to develop locally, the server can be set up as follows:

1. Install RVM according to the [official instructions](https://rvm.io/).
2. Create a gemset and install the required gems by running:
```
$ rvm gemset create vulcan-persistence
$ rvm gemset use vulcan-persistence
$ sudo apt install libpq-dev # Required for PostgreSQL
$ bundle install
```
3. Prepare the test database by running:
```
$bash script/testdb 
$ RAILS_ENV=test rake db:create
$ RAILS_ENV=test rake db:migrate
```
4. Make sure that everything works by running:
```
$ RAILS_ENV=test rake test
```

## Docker execute

Those are the variables you have to use:

|Variable|Description|Sample|
|---|---|---|
|LOG_LEVEL|Rails log level (optional)|DEBUG
|POSTGRES_(HOST\|PORT\|USER\|PASSWORD\|DB)|Database access|
|POSTGRES_SSLMODE|One of these (disable,allow,prefer,require,verify-ca,verify-full)|prefer|
|POSTGRES_CA_B64|A base64 encoded ca certificate||
|SECRET_KEY_BASE|Security key||

```bash
docker build . -t vp

# Use the default local.env customized with env variables.
docker run --env-file ./local.env vp

# Use custom config file.
docker run -v `pwd`/custom.env:/app/.env.config vr

# Optional: If you want to execute sql commands into the database after the migrations.
docker run --env-file ./local.env -v `pwd`/load.db:/tmp/load.db vp /tmp/load.db
```
