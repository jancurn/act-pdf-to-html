
# See https://hub.docker.com/r/bwits/pdf2htmlex-alpine/
FROM bwits/pdf2htmlex

RUN apt-get update --fix-missing \
 && DEBIAN_FRONTEND=noninteractive apt-get -y upgrade \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl ca-certificates \
 && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
 && apt-get install -y nodejs \
 && node -v \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /pdf

# Copy all files and directories from the directory to the Docker image
COPY . ./

# Install NPM packages, skip optional and development dependencies to keep the image small,
# avoid logging to much and show log the dependency tree
RUN npm install --quiet --only=prod --no-optional \
 && npm list

# Define that start command
CMD [ "node", "main.js" ]