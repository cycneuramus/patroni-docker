FROM postgres:15

ARG version=3.1.0
ARG USER=patroni
ARG HOME_DIR=/home/$USER

RUN apt-get update \
	&& apt-get install --no-install-recommends patroni -y \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

RUN adduser \
	--disabled-password \
	--uid 1000 \
	$USER

USER $USER
WORKDIR $HOME_DIR

COPY entrypoint.sh .

ENV DATA_DIR=$HOME_DIR

ENTRYPOINT ["sh", "entrypoint.sh"]
CMD ["--help"]
