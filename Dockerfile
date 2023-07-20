FROM ruby:3.0.2
RUN apt-get update -qq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man

WORKDIR /csit
ENV PORT=8080

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
RUN bundle exec bootsnap precompile --gemfile app/ lib/

EXPOSE 8080
CMD ["./bin/rails", "s", "-b", "0.0.0.0", "-p", "8080"]