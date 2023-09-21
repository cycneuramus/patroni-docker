#!/bin/sh

chmod 0750 "$DATA_DIR"

patroni "$@"
