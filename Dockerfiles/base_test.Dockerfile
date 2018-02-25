FROM elixir:1.6.1-slim

# Download and install Hex and Rebar.
RUN yes | mix do local.rebar, local.hex

# Install build deps.
RUN apt-get update
RUN apt-get install -y git-core postgresql-client

# Add project bin to the PATH.
ENV PATH /app/bin:$PATH
WORKDIR /app

# Set the Mix environment to test.
ENV MIX_ENV test

#    _________________________
#    < This is important. >
#    -------------------------
#           \   ^__^
#            \  (oo)\_______
#               (__)\       )\/\
#                   ||----w |
#                   ||     ||
####################################################################################################
# All commands below this point are ordered in least to most changing. (predicted)
# This is to maximize the use of the Docker cache. It should work well with any Docker based CI.
####################################################################################################


COPY /mix.exs /app/mix.exs
COPY /mix.lock /app/mix.lock
COPY /apps/apollo/mix.exs /app/apps/apollo/mix.exs
COPY /apps/apollo_web/mix.exs /app/apps/apollo_web/mix.exs
RUN mix do deps.get, deps.compile

# Precompile the for test environment, this should always be last.
# This should prevent any compiling when running the test suite.
COPY / /app/
RUN mix compile
