FROM ruby:2.6.6

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

ENV POSTGRES_HOST=froidusuariodb.chidvuv3t7pk.us-east-1.rds.amazonaws.com
ENV POSTGRES_USER=carvesco
ENV POSTGRES_PASSWORD=cavelascor

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
COPY . .

EXPOSE 3000
CMD ["rails", "server", "-b", "ssl://0.0.0.0:3000?key=localhost.key&cert=localhost.crt"]