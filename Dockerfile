# Copyright 2019 Adevinta

FROM ruby:3.3.0-alpine AS pre-builder
ARG bundle_without="" rails_env=production
ENV SECRET_KEY_BASE=dumb
RUN apk add --no-cache \
    openssl \
    tar \
    build-base \
    tzdata \
    postgresql-dev \
    postgresql-client \
    sqlite-dev \
    && mkdir -p /var/app
ENV BUNDLE_PATH="/gems" BUNDLE_JOBS=2 RAILS_ENV=${rails_env} BUNDLE_WITHOUT=${bundle_without}
WORKDIR /var/app
COPY Gemfile* /var/app/
RUN bundle install -j4 --retry 3 \
    && rm -rf /gems/cache/* \
    && find /gems/ -name "*.c" -delete \
    && find /gems/ -name "*.o" -delete

FROM ruby:3.3.0-alpine
ARG build_without="" rails_env=production
RUN apk add --no-cache \
    openssl \
    tzdata \
    postgresql-dev \
    sqlite-dev \
    postgresql-client \
    gettext \
    ca-certificates

COPY --from=pre-builder /gems/ /gems/
ARG bundle_without rails_env
ENV BUNDLE_PATH="/gems" BUNDLE_JOBS=2 RAILS_ENV=${rails_env} BUNDLE_WITHOUT=${bundle_without}
ENV RAILS_LOG_TO_STDOUT=true

WORKDIR /app
COPY . .

CMD ["./run.sh"]
