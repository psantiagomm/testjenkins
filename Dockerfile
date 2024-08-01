# Etapa de construcción
FROM maven:3.9.8-amazoncorretto-21 AS build

WORKDIR /usr/src/app
COPY . .
RUN mvn clean package

# Etapa de ejecución
# Imagen base de Java
FROM amazoncorretto:22-alpine

RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

VOLUME /tmp

WORKDIR /app/

COPY --from=build /usr/src/app/target/*.jar /app/app.jar

#COPY watcher.sh .

# Puerto en el que escucha el servicio
EXPOSE 8080

# Instalación de paquetes adicionales
#RUN apk add --no-cache inotify-tools
#RUN apk add --no-cache wget

#microservicio cuando se ejecute el contenedor
CMD ["java", "-jar", "app.jar"]