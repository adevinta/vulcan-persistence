#!/bin/sh
set -x
bundle exec pumactl --control-url tcp://127.0.0.1:9293 --control-token token status
