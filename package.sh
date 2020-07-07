VERSION=$( xmlstarlet sel \
          -N x='http://maven.apache.org/POM/4.0.0' \
          -t \
          -v '//x:project/x:version/text()' \
          pom.xml \
      )

docker build \
--build-arg RELEASE_VERSION=0.0.1-SNAPSHOT \
-f kontainer.Dockerfile \
-t kontainer-$VERSION . \
&& docker run kontainer-$VERSION