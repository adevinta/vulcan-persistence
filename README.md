[![Build Status](https://travis-ci.org/adevinta/vulcan-persistence.svg?branch=master)](https://travis-ci.org/adevinta/vulcan-persistence)
[![codecov](https://codecov.io/gh/adevinta/vulcan-persistence/branch/master/graph/badge.svg)](https://codecov.io/gh/adevinta/vulcan-persistence)

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
|POSTGRES_(HOST\|PORT\|USER\|PASSWORD\|DB)|Database access|
|POSTGRES_SSLMODE|One of these (disable,allow,prefer,require,verify-ca,verify-full)|prefer|
|POSTGRES_CA_B64|A base64 encoded ca certificate||
|SECRET_KEY_BASE|Security key||
|STREAM_CHANNEL|Postgres channel|events|
|REGION|AWS region|eu-west-1|
|SCANS_BUCKET|S3 bucket for scans|my-vulcan-scan-bucket|
|SNS_TOPIC_ARN|Sns topic arn|arn:aws:sns:eu-west-1:xxx:yyy|
|AWS_CREATE_CHECKS_SQS_URL| url of the queue for the workers to async create checks (optional)
|AWS_CREATE_CHECKS_WORKERS| number of "create checks" workers to init (optional)


You can specify custom AWS endpoints for testing/developing purposes for each one of the
 AWS services used in Vulcan Persistence, for example, by using [Minio](https://min.io/) or [LocalStack](https://localstack.cloud/).  

You just need to provide the following env vars:

|Variable|Description|Sample|
|---|---|---|
|AWS_SQS_ENDPOINT|Custom AWS SQS endpoint|http://localhost:4100 |
|AWS_SNS_ENDPOINT|custom AWS SNS endpoint|http://localhost:4100 |
|AWS_S3_ENDPOINT|custom AWS S3 endpoint|http://localhost:9000 |

```bash
docker build . -t vp

# Use the default local.env customized with env variables.
docker run --env-file ./local.env vp

# Use custom config file.
docker run -v `pwd`/custom.env:/app/.env.config vr

# Optional: If you want to execute sql commands into the database after the migrations.
docker run --env-file ./local.env -v `pwd`/load.db:/tmp/load.db vp /tmp/load.db
```
