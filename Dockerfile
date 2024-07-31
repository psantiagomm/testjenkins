# Imagen base de Java
FROM amazoncorretto:22-alpine

RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

VOLUME /tmp

WORKDIR /app/
# Copia el archivo JAR al contenedor
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar

#COPY watcher.sh .

# Puerto en el que escucha el servicio
EXPOSE 8080

# Instalación de paquetes adicionales
#RUN apk add --no-cache inotify-tools
#RUN apk add --no-cache wget

#microservicio cuando se ejecute el contenedor
CMD ["java", "-jar", "app.jar"]