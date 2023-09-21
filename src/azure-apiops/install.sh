
set -e

. ./library_scripts.sh

# nanolayer is a cli utility which keeps container layers as small as possible
# source code: https://github.com/devcontainers-contrib/nanolayer
# `ensure_nanolayer` is a bash function that will find any existing nanolayer installations, 
# and if missing - will download a temporary copy that automatically get deleted at the end 
# of the script
ensure_nanolayer nanolayer_location "v0.5.3"

architecture="$(uname -m)"
case ${architecture} in
x86_64) architecture="linux-x64" ;;
aarch64 | armv8*) architecture="linux-arm64" ;;
*)
	echo "(!) Architecture ${architecture} unsupported"
	exit 1
	;;
esac

echo "Architecture: ${architecture}"

$nanolayer_location \
    install \
    devcontainer-feature \
    "ghcr.io/devcontainers-contrib/features/gh-release:1.0.21" \
    --option repo='Azure/apiops' --option binaryNames='extractor' --option assetRegex="^extractor.${architecture}.exe" --option version="$VERSION"
    


$nanolayer_location \
    install \
    devcontainer-feature \
    "ghcr.io/devcontainers-contrib/features/gh-release:1.0.21" \
    --option repo='Azure/apiops' --option binaryNames='publisher' --option assetRegex="^publisher.${architecture}.exe" --option version="$VERSION"
    

echo 'Done!'

