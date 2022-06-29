FROM maven:3-adoptopenjdk-8@sha256:bb2c2ab9cd24a13fe5f494d22c9404459613c603446b7c60afb1a945bc40aa5b AS build
ARG VERSION=1.11.1
RUN git clone --single-branch --depth=1 --branch=apache-parquet-${VERSION} https://github.com/apache/parquet-mr.git

COPY 00.patch /tmp/

WORKDIR /parquet-mr/parquet-tools
RUN patch -u -p2 < /tmp/00.patch
RUN mvn package -Plocal
RUN cp /parquet-mr/parquet-tools/target/parquet-tools-${VERSION}.jar /parquet-tools.jar

FROM adoptopenjdk/openjdk8:alpine-jre@sha256:74d6e207df49d971632712520883328a2cc944af0669c75838cd6dd9c9b6f1fb

RUN apk add --no-cache tini

COPY --from=build /parquet-tools.jar /parquet-tools.jar

ENTRYPOINT ["/sbin/tini", "--", "java", "-XX:-UsePerfData", "-jar", "/parquet-tools.jar"]
