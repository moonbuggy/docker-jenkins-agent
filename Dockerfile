ARG JRE_VERSION='11.0.11_9'
ARG JRE_OS='debianslim'
ARG FROM_IMAGE="adoptopenjdk/openjdk11:jre-${JRE_VERSION}-${JRE_OS}"

ARG REMOTING_VERSION="4.10"

ARG TARGET_ARCH_TAG="amd64"

ARG JENKINS_USER="jenkins"
ARG JENKINS_GROUP="jenkins"
ARG PUID="1000"
ARG GUID="1000"

ARG AGENT_WORKDIR="/home/${JENKINS_USER}/agent"


## get files we need
#
FROM moonbuggy2000/fetcher:latest AS fetcher

WORKDIR /fetcher_root/usr/share/jenkins
ARG REMOTING_VERSION
RUN wget -qO agent.jar "https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${REMOTING_VERSION}/remoting-${REMOTING_VERSION}.jar" \
  && chmod 755 ./ \
  && chmod 644 agent.jar \
  && ln -sf agentjar slave.jar


## build the image
#
FROM "${FROM_IMAGE}" AS builder

# QEMU static binaries from pre_build
ARG QEMU_DIR
ARG QEMU_ARCH
COPY _dummyfile "${QEMU_DIR}/qemu-${QEMU_ARCH}-static*" /usr/bin/

# RUN DEBIAN_FRONTEND=noninteractive \
#   && apt-get update \
#   && apt-get install -qy --no-install-recommends \
#     gnupg2 \
#   && curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash

RUN DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get install -qy --no-install-recommends \
    git \
    git-lfs \
    openssh-client \
    openssl \
    procps

ARG JENKINS_USER
ARG JENKINS_GROUP
ARG PUID
ARG GUID

RUN addgroup --gid "${GUID}" "${JENKINS_GROUP}" \
  && adduser --gecos "" --home "/home/${JENKINS_USER}" --uid "${PUID}" --ingroup "${JENKINS_GROUP}" --disabled-password "${JENKINS_USER}"

ARG AGENT_WORKDIR
ENV AGENT_WORKDIR="${AGENT_WORKDIR}"
RUN mkdir "/home/${JENKINS_USER}/.jenkins" \
  && mkdir -p "${AGENT_WORKDIR}" \
  && chown -R "${PUID}:${GUID}" "/home/${JENKINS_USER}" \
  && chmod -R 777 "${AGENT_WORKDIR}"

RUN rm -f "/usr/bin/qemu-${QEMU_ARCH}-static" >/dev/null 2>&1


## drop QEMU static binaries
#
FROM "moonbuggy2000/scratch:${TARGET_ARCH_TAG}"

COPY --from=builder / /
COPY --from=fetcher /fetcher_root/ /

ARG AGENT_WORKDIR
ARG JENKINS_USER
VOLUME "/home/${JENKINS_USER}/.jenkins"
VOLUME "${AGENT_WORKDIR}"

ENV JAVA_HOME="/opt/java/openjdk/" \
    PATH="/opt/java/openjdk/bin:${PATH}"

USER "${JENKINS_USER}"

WORKDIR "/home/${JENKINS_USER}"
