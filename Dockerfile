FROM  maven:3.8.3-openjdk-17  AS base
 
WORKDIR /app

COPY . .

RUN mvn clean package -DskipTests 

FROM  maven:3.8.3-openjdk-17  AS runtime

WORKDIR /app

COPY --from=base /app/target /app/target


EXPOSE 8080

CMD ["java", "-jar","target/boardgame-0.0.7.jar"]
