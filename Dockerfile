FROM adoptopenjdk/openjdk8:x86_64-alpine-jre8u222-b10

ENV LOGBACK_VERSION=1.2.3 \
	WIREMOCK_VERSION=2.24.1 \
	LOGBACK_CLASSIC=logback-classic \
	LOGBACK_CORE=logback-core \
	WIREMOCK_STANDALONE=wiremock-standalone \
	LIB_DIR=/wiremock/lib \
	MAVEN_REPO=http://repo1.maven.org/maven2

RUN apk --no-cache add curl

RUN mkdir -p $LIB_DIR && \
	curl -o $LIB_DIR/$LOGBACK_CLASSIC.jar $MAVEN_REPO/ch/qos/logback/$LOGBACK_CLASSIC/$LOGBACK_VERSION/$LOGBACK_CLASSIC-$LOGBACK_VERSION.jar && \
	curl -o $LIB_DIR/$LOGBACK_CORE.jar $MAVEN_REPO/ch/qos/logback/$LOGBACK_CORE/$LOGBACK_VERSION/$LOGBACK_CORE-$LOGBACK_VERSION.jar && \
	curl -o $LIB_DIR/$WIREMOCK_STANDALONE.jar $MAVEN_REPO/com/github/tomakehurst/$WIREMOCK_STANDALONE/$WIREMOCK_VERSION/$WIREMOCK_STANDALONE-$WIREMOCK_VERSION.jar

WORKDIR /wiremock

COPY ./logback.xml .

RUN mkdir root

ENTRYPOINT ["java", "-Dlogback.configurationFile=logback.xml", "-cp", "lib/*", "com.github.tomakehurst.wiremock.standalone.WireMockServerRunner", "--root-dir=root"]
