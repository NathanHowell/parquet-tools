FROM maven:3-adoptopenjdk-8@sha256:bb2c2ab9cd24a13fe5f494d22c9404459613c603446b7c60afb1a945bc40aa5b AS build
RUN git clone --single-branch --depth=1 --branch=apache-parquet-1.11.1 https://github.com/apache/parquet-mr.git

COPY 00.patch /tmp/

WORKDIR /parquet-mr/parquet-tools
RUN patch -u -p2 < /tmp/00.patch
RUN mvn package -Plocal

FROM adoptopenjdk/openjdk8:alpine-jre@sha256:57de6fc64c379286080a1c09dcf91dc3c26d70860f97866cd19188cf99134caf

RUN apk add --no-cache tini

COPY --from=build /parquet-mr/parquet-tools/target/parquet-tools-1.11.1.jar /parquet-tools.jar

ENTRYPOINT ["/sbin/tini", "--", "java", "-XX:-UsePerfData", "-jar", "/parquet-tools.jar"]

