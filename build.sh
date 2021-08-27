#! /bin/bash
# shellcheck disable=SC2034

#NOOP='true'
#DO_PUSH='true'
#NO_BUILD='true'

DOCKER_REPO="${DOCKER_REPO:-moonbuggy2000/jenkins-agent}"

all_tags='agent-alpine agent-debian inbound-agent-alpine inbound-agent-debian'
default_tag='latest'

. "hooks/.build.sh"
