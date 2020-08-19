FROM maven:3-adoptopenjdk-8@sha256:bb2c2ab9cd24a13fe5f494d22c9404459613c603446b7c60afb1a945bc40aa5b AS build

RUN git clone --single-branch --depth=1 --branch=apache-parquet-1.11.0 https://github.com/apache/parquet-mr.git

WORKDIR /parquet-mr/parquet-tools
RUN mvn package -Plocal

FROM adoptopenjdk/openjdk8:alpine-jre@sha256:ef78cb7ac49bd89c54cb6220eafb082a787681697a11b457f761ea8228bc98f1

RUN apk add --no-cache tini

COPY --from=build /parquet-mr/parquet-tools/target/parquet-tools-1.11.0.jar /parquet-tools.jar

ENTRYPOINT ["/sbin/tini", "--", "java", "-XX:-UsePerfData", "-jar", "/parquet-tools.jar"]

