#!/bin/bash

set -e

source dev-container-features-test-lib

# These tests are run as root

check "Porter version" /root/.porter/porter version
check "List all mixins" /root/.porter/porter mixins list
check "exec mixin installed" /root/.porter/mixins/exec/exec version

reportResults
