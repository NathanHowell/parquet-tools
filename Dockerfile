FROM maven:3-adoptopenjdk-8@sha256:bb2c2ab9cd24a13fe5f494d22c9404459613c603446b7c60afb1a945bc40aa5b AS build
RUN git clone --single-branch --depth=1 --branch=apache-parquet-1.11.1 https://github.com/apache/parquet-mr.git

COPY 00.patch /tmp/

WORKDIR /parquet-mr/parquet-tools
RUN patch -u -p2 < /tmp/00.patch
RUN mvn package -Plocal

FROM adoptopenjdk/openjdk8:alpine-jre@sha256:3301518282868b8912e3d7b56f3b2e393d38325a326a5ab3b09581502d0737aa

RUN apk add --no-cache tini

COPY --from=build /parquet-mr/parquet-tools/target/parquet-tools-1.11.1.jar /parquet-tools.jar

ENTRYPOINT ["/sbin/tini", "--", "java", "-XX:-UsePerfData", "-jar", "/parquet-tools.jar"]

