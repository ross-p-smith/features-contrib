#!/bin/bash -i

set -e

source dev-container-features-test-lib

check "porter --version" porter --version

echo "PORTER_HOME: $PORTER_HOME"
echo "User: $(whoami)"
echo "Remote User: $_REMOTE_USER"

ls -al "$PORTER_HOME"
#ls -al "$PORTER_HOME/mixins"

# Old check with grep
check "porter mixin list | grep terraform" porter mixin list | grep terraform

check "porter mixin list | grep az" porter mixin list | grep az

check "porter mixin list | grep aws" porter mixin list | grep aws

check "porter mixin list | grep docker" porter mixin list | grep docker

check "porter mixin list | grep docker-compose" porter mixin list | grep docker-compose

check "porter mixin list | grep gcloud" porter mixin list | grep gcloud

check "porter mixin list | grep helm" porter mixin list | grep helm

check "porter mixin list | grep arm" porter mixin list | grep arm

check "porter plugin list | grep azure" porter plugin list | grep azure

check "porter plugin list | grep kubernetes" porter plugin list | grep kubernetes

# Check File permissions in GH Actions. (Works locally, but not in GH Actions)
ls -al "$PORTER_HOME/mixins/exec"

check "exec mixin installed" "$PORTER_HOME"/mixins/exec/exec version
check "terraform mixin installed" "$PORTER_HOME"/mixins/terraform/terraform version
check "az mixin installed" "$PORTER_HOME"/mixins/az/az version
check "docker mixin installed" "$PORTER_HOME"/mixins/docker/docker version
check "docker-compose mixin installed" "$PORTER_HOME"/mixins/docker-compose/docker-compose version
check "gcloud mixin installed" "$PORTER_HOME"/mixins/gcloud/gcloud version
check "helm mixin installed" "$PORTER_HOME"/mixins/helm/helm version
check "arm mixin installed" "$PORTER_HOME"/mixins/arm/arm version
check "azure plugin installed" "$PORTER_HOME"/plugins/azure/azure version
check "kubernetes plugin installed" "$PORTER_HOME"/plugins/kubernetes/kubernetes version

reportResults
