FROM maven:3-jdk-8-alpine AS build

RUN apk add --no-cache ca-certificates git
RUN git clone --single-branch --depth=1 --branch=apache-parquet-1.9.0 https://github.com/apache/parquet-mr.git

WORKDIR /parquet-mr/parquet-tools
RUN mvn package -Plocal

FROM openjdk:8-jre-alpine

RUN apk add --no-cache tini libc6-compat

COPY --from=build /parquet-mr/parquet-tools/target/parquet-tools-1.9.0.jar /parquet-tools.jar

ENTRYPOINT ["/sbin/tini", "--", "java", "-XX:-UsePerfData", "-jar", "/parquet-tools.jar"]

