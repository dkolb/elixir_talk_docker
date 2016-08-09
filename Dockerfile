FROM elixir:slim
MAINTAINER David Kolb <david.kolb@krinchan.com>
ARG MIX_ENV
ENV MIX_ENV ${MIX_ENV:-aws-dev}


# Do this first before any copies because YAY caching.
RUN mix local.hex --force && \
      mix local.rebar --force

# Copy in for dependencies image which changes less.
COPY mix.exs mix.lock /app_src/

#Get and compile deps.
WORKDIR /app_src/
RUN mix do deps.get, deps.compile

# Compile the source code, move the release, delete source code.
COPY config/ /app_src/config
COPY lib/ /app_src/lib
COPY version.txt /app_src/
RUN mix do compile, release && \
      mv /app_src/rel /app && \
      mkdir /app/hello_world/log

# Copy the run script so we can catch SIGTERM and terminate properly.
# Don't ask me why this has to be in perl.  Bash scripts and trap
# didn't work.  ¯\_(ツ)_/¯
COPY run.pl /app/
RUN chmod a+x /app/run.pl

# And set a nice home directory for those exec /bin/bash's
WORKDIR /app/

# Expose our ports.
EXPOSE 4001

# And give a nice default for spinning up the image.
CMD ["/app/run.pl"]

