FROM  maven:3.8.3-openjdk-17  AS base
    
WORKDIR /app

COPY target/*.jar .
   

EXPOSE 8080

CMD ["java", "-jar","*.jar"]
