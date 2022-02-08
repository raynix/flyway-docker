FROM curlimages/curl as builder

ENV FLYWAY_VERSION 8.4.4

WORKDIR /flyway

RUN curl -L https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}.tar.gz -o flyway-commandline-${FLYWAY_VERSION}.tar.gz \
  && gzip -d flyway-commandline-${FLYWAY_VERSION}.tar.gz \
  && tar -xf flyway-commandline-${FLYWAY_VERSION}.tar --strip-components=1 \
  && rm flyway-commandline-${FLYWAY_VERSION}.tar

FROM eclipse-temurin:11-jre

RUN adduser --system --home /flyway --disabled-password --group flyway
WORKDIR /flyway

USER flyway

COPY --chown=flyway:flyway --from=builder /flyway /flyway

ENV PATH="/flyway:${PATH}"

ENTRYPOINT ["flyway"]
CMD ["-?"]
