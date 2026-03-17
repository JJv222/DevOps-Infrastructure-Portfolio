FROM jenkins/jenkins:lts

ARG JENKINS_REF=/usr/share/jenkins/ref
ARG JENKINS_CONFIG=/var/jenkins_config
ARG ENTRYPOINT=/entrypoint.sh

USER root 

COPY ./controllerData/plugins.txt ${JENKINS_REF}/plugins.txt
COPY casc.yaml ${JENKINS_REF}/casc.yaml
COPY ./controllerData/init-pipeline.groovy ${JENKINS_CONFIG}/init-pipeline.groovy
COPY ./controllerData/scripts/. /scripts
COPY ./controllerData/piplines/. /piplines
COPY entrypoint.sh ${ENTRYPOINT}

RUN jenkins-plugin-cli --plugin-file ${JENKINS_REF}/plugins.txt && \
    chmod +x ${ENTRYPOINT}

ENV CASC_JENKINS_CONFIG=${JENKINS_REF}/casc.yaml

ENTRYPOINT ["/entrypoint.sh"]