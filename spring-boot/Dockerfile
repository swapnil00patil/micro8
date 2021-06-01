FROM adoptopenjdk/openjdk14

ARG JAR_FILE=build/libs/*.jar

RUN apt-get update && apt-get install -y socat

COPY ${JAR_FILE} spring-demo.jar

CMD java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005 -jar spring-demo.jar
