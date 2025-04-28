FROM ruby:3.3

RUN apt-get update -qq  \
  && apt-get install -y build-essential \
  && apt-get install -y --no-install-recommends ca-certificates curl firefox-esr \
  && rm -fr /var/lib/apt/lists/* \
  && curl -L https://github.com/mozilla/geckodriver/releases/download/v0.30.0/geckodriver-v0.30.0-linux64.tar.gz | tar xz -C /usr/local/bin \
  && apt-get purge -y ca-certificates curl

RUN mkdir /rulethu_stock_exchange 
WORKDIR /rulethu_stock_exchange

COPY Gemfile /rulethu_stock_exchange/Gemfile
COPY Gemfile.lock /rulethu_stock_exchange/Gemfile.lock
COPY lib/rulethu_stock_exchange/version.rb /rulethu_stock_exchange/lib/rulethu_stock_exchange/version.rb
COPY rulethu_stock_exchange.gemspec /rulethu_stock_exchange/rulethu_stock_exchange.gemspec

RUN bundle 

COPY . /rulethu_stock_exchange

