
FROM debian:jessie

RUN apt-get update --fix-missing \
 && DEBIAN_FRONTEND=noninteractive apt-get -y upgrade \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl ca-certificates pdf2htmlex \
 && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
 && apt-get install -y nodejs \
 && node -v \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /pdf/kv-store-dev

WORKDIR /pdf

# Copy all files and directories from the directory to the Docker image
COPY main.js package.json ./
COPY kv-store-dev/* ./kv-store-dev/

# Install NPM packages, skip optional and development dependencies to keep the image small,
# avoid logging to much and show log the dependency tree
RUN npm install --quiet --only=prod --no-optional \
 && npm list \
 && pwd \
 && ls -l

# Define that start command
CMD [ "node", "main.js" ]