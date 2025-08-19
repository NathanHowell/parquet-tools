FROM maven:3.8-adoptopenjdk-16@sha256:0698e6fffa705bd7ecc6aea01c982fd51c32d44cf6eb09ea8bffd5067ff80307 AS build
ARG VERSION=1.11.1
RUN git clone --single-branch --depth=1 --branch=apache-parquet-${VERSION} https://github.com/apache/parquet-mr.git

COPY 00.patch /tmp/

WORKDIR /parquet-mr/parquet-tools
RUN patch -u -p2 < /tmp/00.patch
RUN mvn package -Plocal
RUN cp /parquet-mr/parquet-tools/target/parquet-tools-${VERSION}.jar /parquet-tools.jar

FROM adoptopenjdk/openjdk8:alpine-jre@sha256:6fb0b2a4f7b2351e2dded6eed34c537ef1e1092cb42ca6e4596c892f4b66d0fb

RUN apk add --no-cache tini

COPY --from=build /parquet-tools.jar /parquet-tools.jar

ENTRYPOINT ["/sbin/tini", "--", "java", "-XX:-UsePerfData", "-jar", "/parquet-tools.jar"]
