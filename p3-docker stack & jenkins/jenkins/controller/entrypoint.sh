#!/bin/bash
set -e

if [ -f "$JENKINS_ADMIN_PASSWORD" ]; then
  export JENKINS_ADMIN_PASSWORD="$(cat $JENKINS_ADMIN_PASSWORD)"
fi

if [ -f "$JENKINS_GITHUB_TOKEN" ]; then
  export JENKINS_GITHUB_TOKEN="$(cat $JENKINS_GITHUB_TOKEN)"
fi

if [ -f "$JENKINS_SLACK_TOKEN" ]; then
  export JENKINS_SLACK_TOKEN="$(cat $JENKINS_SLACK_TOKEN)"
fi

if [ -f "$SSH_WORKER1_KEY" ]; then
  export SSH_WORKER1_KEY="$(cat $SSH_WORKER1_KEY)"
fi

if [ -f "$SSH_MANAGER_KEY" ]; then
  export SSH_MANAGER_KEY="$(cat $SSH_MANAGER_KEY)"
fi


cp /var/jenkins_config/init-pipeline.groovy /usr/share/jenkins/ref/init.groovy.d/

exec /usr/bin/tini -- /usr/local/bin/jenkins.sh