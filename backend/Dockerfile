FROM maven:3.9.3-eclipse-temurin-20-alpine as builder
ARG VERSION=${VERSION}
WORKDIR /usr/src/app
COPY ./src ./src
COPY *.xml ./
RUN curl https://storage.yandexcloud.net/cloud-certs/CA.pem -o YandexInternalRootCA.crt \
    && mvn package -Dversion.application=${VERSION} -Dmaven.test.skip=true

# шаг релиза
FROM openjdk:19-jdk-alpine3.16
ARG VERSION=${VERSION}
WORKDIR /app
RUN apk update && apk add curl
COPY --from=builder /usr/src/app/YandexInternalRootCA.crt .
RUN keytool -importcert -file YandexInternalRootCA.crt \
    -alias yandex -cacerts -storepass changeit -noprompt \
    && addgroup --system backend \
    && adduser -S -s /bin/false -G backend backend -h /home/backend -D && \
    mkdir -p /home/backend/.postgresql && \
    cp YandexInternalRootCA.crt /home/backend/.postgresql/root.crt && \
    chmod 0600 /home/backend/.postgresql/root.crt && \
    rm -f YandexInternalRootCA.crt && chown -R backend:backend /home/backend/.postgresql
COPY --chown=backend:backend \
     --from=builder /usr/src/app/target/sausage-store-${VERSION}.jar ./sausage-store.jar
EXPOSE 8080
USER backend
ENTRYPOINT ["java", "-jar", "-Dmyserver.bindPort=8080", "/app/sausage-store.jar"]