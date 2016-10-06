
FROM ruby:2.2.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get  -y install nodejs

RUN mkdir /bikerails
WORKDIR /bikerails
ADD Gemfile /bikerails/Gemfile
ADD Gemfile.lock /bikerails/Gemfile.lock
RUN bundle install
RUN cd $(npm root -g)/npm \
&& npm install fs-extra \
&& sed -i -e s/graceful-fs/fs-extra/ -e s/fs.rename/fs.move/ ./lib/utils/rename.js


ADD . /bikerails
RUN npm install
RUN npm config set user 0
RUN npm config set unsafe-perm true
WORKDIR /bikerails/client
RUN npm install
WORKDIR /bikerails
