#!/bin/sh

# Fail on error
set -o pipefail

# Define md5sum or md5 depending on Linux/OSX
MD5=
if [[ "$(uname -s)" == "Darwin" ]]; then
    MD5="md5 -r"
else
    MD5="md5sum"
fi

# Display usage text.
usage() {
    
    echo "Usage: build.sh."
    echo "Description: Builds a Docker Image for Oracle Endeca Commerce"
    echo "Author: Eder Saúl Quinñones Ortega"

    echo ""
    echo "Parameters: "
    echo "\t-v: version to build"
    echo "\t\t $(for i in $(ls -d */); do echo -n "${i%%/}  "; done)"
    exit 0
}

# Install Files
declare -a files=(
    "V861198-01.zip"
    "V861200-01.zip"
    "V861203-01.zip"
    "V861206-01.zip"
)

# Validate Installers
validateInstallers() {
    echo "Checking the existence of the required packages in software directory"
    for file in "${files[@]}"
    do
        if [ ! -f ocgsem-11.3/software/$file ]; then
            echo "ERROR: Missing installer file: $file"
            exit 1
        else
            echo "File: $file found."
        fi
    done
}

# Validate Packages
checksumPackages() {
    echo "Checking md5sum of packages"
    for file in "${files[@]}"
    do
        checksumValidated=`cat ocgsem-11.3/software/$file.md5`
        if hash md5sum 2>/dev/null; then
            packageChecksum=`$MD5 ocgsem-11.3/software/$file | awk '{print $1}'`

            if [ ! $checksumValidated = $packageChecksum ]; then
                echo "ERROR: md5sum for $file does not match. File is corrupt."
                exit 1
            else
                echo "Checksum for $file matches."
            fi
        elif hash md5 2>/dev/null; then
            packageChecksum=`$MD5 ocgsem-11.3/software/$file | awk '{print $1}'`

            if [ ! $checksumValidated = $packageChecksum ]; then
                echo "ERROR: md5sum for $file does not match. File is corrupt."
                exit 1
            else
                echo "Checksum for $file matches"
            fi
        else
            echo "Ignored MD5 Checksum, command is not available in the hosting machine."
        fi
    done
}

# File
FILE=ocgsem-11.3

# Image name
IMAGE=ocgsem/endeca

# Cache flag
NO_CACHE=false

# Use Endeca JVM
USE_ENDECA_JVM=true

if [ "$#" -eq 0 ]; then
  usage;
fi

while getopts "hv:o" option; do
    case $option in
        "h")
            usage;
            ;;
        "v")
            VERSION="$OPTARG"
            ;;
        "?")
            exit
            ;;
        *)
            echo "ERROR: Unknown option to be parsed."
            ;;
    esac
done

cd $VERSION

if [ "$VERSION" == "11.3" ]; then
    OPTIONS="";
else
    echo "ERROR: Version $VERSION is not yet supported.";
    exit 1;
fi

# Oracle Commerce Image 
IMAGE_NAME="$IMAGE:$VERSION"

# Building Image Name
echo "Building image '$IMAGE_NAME': ..."

BUILD_START=$(date '+%s')

docker build --rm --no-cache=$NO_CACHE --build-arg ENDECA_JVM=$USE_ENDECA_JVM -t $IMAGE_NAME -f Dockerfile . || {
    echo "\n"
    
    echo "ERROR: Oracle Commerce Docker image could not be successfully created."
    echo "ERROR: Check the log build file in order to find the related to the build operation."
    
    exit 1
}

BUILD_END=$(date '+%s')
BUILD_ELAPSED=`expr $BUILD_END - $BUILD_START`

cat << EOF
    Build completed in $BUILD_ELAPSED seconds.
EOF

