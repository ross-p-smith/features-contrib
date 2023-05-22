#!/bin/bash

set -e

source dev-container-features-test-lib

# These tests are running as a vscode user in the container

check "Porter version" /home/vscode/.porter/porter version
check "List all Mixins" /home/vscode/.porter/porter mixin list
check "az mixin installed" /home/vscode/.porter/mixins/az/az version
check "azure plugin installed" /home/vscode/.porter/plugins/azure/azure version

reportResults
