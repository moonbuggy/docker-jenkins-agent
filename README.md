# Docker Jenkins Agent
Based on [jenkinsci/docker-agent](https://github.com/jenkinsci/docker-agent), built for multiple architectures. These images should produce containers that function the same as the official agent container, so follow their instructions for usage.

## Tags
Lazy tags:

-   ``agent``/``agent-debianslim``                   - latest remoting version with JRE11 in Debian slim
-   ``agent-alpine``                                 - latest remoting version with JRE8 in Alpine
-   ``inbound-agent``/``inbound-agent-debianslim``   - latest remoting version with JRE11 in Debian slim
-   ``inbound-agent-alpine``                         - latest remoting version with JRE8 in Alpine

Full tags are in the form `<agent_type>-<remoting_version>-jre<jre_version>-<OS>-<arch>`.

`agent_type` is `agent` or `inbound-agent`, `OS` will be either `alpine` or `debianslim` (the default).

Currently all Alpine builds use JRE8, and all Debian builds use JRE11.

`arch` shouldn't need to be specified, Docker should automatically pull the appropriate image for any compatible platform.

## Architectures
-   Alpine: `amd64`, `arm64`, `armv6`, `armv7`, `386`, `ppc64le`
-   Debian: `amd64`, `arm64`, `armv7`, `ppc64le`

## Notes
The Alpine images are smaller and thus preferable if they're going to be run on ARM devices with limited storage, but there's no easy way to get Alpine+JRE11, so we're stuck with JRE8. This seems to be problematic for JNLP connections, which throw a variety of Java errors. The Alpine containers may work the WebSocket okay though, but I've not tested this.

JRE8 might work better with older versions of the remoting or jenkins-agent scripts (the images use the latest versions at build time), but it may not be worth the effort of investigating.

The Debian+JRE11 images work as expected via JNLP.

## To-do
-   add a mechanism to import and configure a root CA, so self-signed certificates don't break WebSocket connection attempts
-   allow PUID/GUID to be set via ENV, for more control over access on the host

## Links
GitHub: <https://github.com/moonbuggy/docker-jenkins-agent>

Docker Hub: <https://hub.docker.com/r/moonbuggy2000/jenkins-agent>
