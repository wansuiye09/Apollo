FROM node:9.5-slim

# Install Chrome so tests can run.
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update
RUN apt-get install google-chrome-stable -y

WORKDIR /app

# Add project bin to the PATH and create priv folder.
ENV PATH /app/node_modules/.bin:$PATH

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

# Install Node packages.
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json
RUN npm install

# Add codebase, optimize later.
COPY / /app/
