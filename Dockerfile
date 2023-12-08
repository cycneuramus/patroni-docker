FROM alpine:3.18 as wal-g

RUN apk add --no-cache wget \
	&& wget -q https://github.com/wal-g/wal-g/releases/download/v2.0.1/wal-g-pg-ubuntu-20.04-amd64 -O /wal-g \
	&& chmod 777 /wal-g

# FROM postgres:15
FROM tensorchord/pgvecto-rs:pg15-latest

ARG version=3.1.0
ARG USER=patroni
ARG HOME_DIR=/home/$USER

RUN apt-get update \
	&& apt-get install --no-install-recommends patroni -y \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=wal-g /wal-g /usr/local/bin/wal-g

RUN adduser \
	--disabled-password \
	--uid 1000 \
	$USER

USER $USER
WORKDIR $HOME_DIR

COPY entrypoint.sh .

ENV DATA_DIR=$HOME_DIR/data

ENTRYPOINT ["sh", "entrypoint.sh"]
CMD ["--help"]
