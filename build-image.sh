#!/bin/sh -e

docker build -t cabot-build -f Dockerfile.build .
rm -rf build/*.whl
docker run --rm -v `pwd`/build:/build cabot-build "cp /code/dist/*.whl /build/"
CABOT_VERSION=`docker run --rm cabot-build 'git describe --tags'`
cp build/*.whl $CABOT_VERSION/
docker build --squash -t cabotapp/cabot -t cabotapp/cabot:$CABOT_VERSION -f $CABOT_VERSION/Dockerfile $CABOT_VERSION/
echo "Successfully built image cabotapp/cabot:$CABOT_VERSION"
docker tag cabotapp/cabot:$CABOT_VERSION cabotapp/cabot:latest
echo "Tagged image as cabotapp/cabot:latest"
