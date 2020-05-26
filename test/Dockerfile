FROM maven:3.6.3-openjdk-8-slim

WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline
COPY . .

CMD mvn test
