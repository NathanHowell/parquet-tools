FROM maven:3-adoptopenjdk-8@sha256:bb2c2ab9cd24a13fe5f494d22c9404459613c603446b7c60afb1a945bc40aa5b AS build
RUN git clone --single-branch --depth=1 --branch=apache-parquet-1.11.1 https://github.com/apache/parquet-mr.git

COPY 00.patch /tmp/

WORKDIR /parquet-mr/parquet-tools
RUN patch -u -p2 < /tmp/00.patch
RUN mvn package -Plocal

FROM adoptopenjdk/openjdk8:alpine-jre@sha256:ab1c48246acc8b969a0880bb53639ec9a1d202602d9dff98d8081cfa2695d845

RUN apk add --no-cache tini

COPY --from=build /parquet-mr/parquet-tools/target/parquet-tools-1.11.1.jar /parquet-tools.jar

ENTRYPOINT ["/sbin/tini", "--", "java", "-XX:-UsePerfData", "-jar", "/parquet-tools.jar"]

