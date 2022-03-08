FROM ruby:${RUBY_VERSION}

RUN apt-get update -qq && apt-get install -y build-essential sudo
RUN mkdir -p ${APP_HOME} && mkdir ${APP_HOME}/log

WORKDIR ${APP_HOME}

COPY . .

RUN ${APP_HOME}/bin/install_gems
