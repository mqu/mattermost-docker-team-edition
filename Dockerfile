FROM alpine:latest

# Some ENV variables
ENV PATH="/mattermost/bin:${PATH}"
ENV MM_VERSION=5.2.0

# Build argument to set Mattermost edition
ARG edition=team

# Install some needed packages
RUN apk add --no-cache \
	ca-certificates \
	curl \
	jq \
	libc6-compat \
	libffi-dev \
	linux-headers \
	mailcap \
	netcat-openbsd \
	xmlsec-dev \
	mariadb-client \
	&& rm -rf /tmp/*

# Get Mattermost
RUN mkdir -p /mattermost/data

ADD https://releases.mattermost.com/$MM_VERSION/mattermost-$MM_VERSION-linux-amd64.tar.gz /mattermost/download/mattermost.tar.gz

WORKDIR /
RUN zcat /mattermost/download/mattermost.tar.gz | tar -xvf - ; \
  rm -fr /mattermost/download ; \
  cp -rp /mattermost/config /mattermost/config-backup ; \
  chown -R root:root /mattermost

#Healthcheck to make sure container is ready
HEALTHCHECK CMD curl --fail http://localhost:8000 || exit 1

# Configure entrypoint and command
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
WORKDIR /mattermost
CMD ["mattermost"]

# Expose port 8000 of the container
EXPOSE 8000

# Declare volumes for mount point directories
VOLUME ["/mattermost/data", "/mattermost/logs", "/mattermost/config"]
