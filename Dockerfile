# Etapa de construcción
FROM maven:3.9.8-amazoncorretto-21 AS build

WORKDIR /app/

COPY ./pom.xml ./
RUN mkdir -p /root/.m2 && mvn -B dependency:resolve

# Copiar el código fuente de la aplicación
COPY ./src ./src

RUN mvn -B package -DskipTests

# Etapa de ejecución
# Imagen base de Java
FROM amazoncorretto:22-alpine
USER root

COPY ./scripts/handle-charset.sh /usr/local/bin/handle-charset.sh
RUN chmod +x /usr/local/bin/handle-charset.sh

# Instalar 'file' para herramientas adicionales si es necesario
RUN apk update && apk add --no-cache file recode

RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

VOLUME /tmp

WORKDIR /app


COPY --from=build /app/target/*.jar /app/app.jar
COPY ./aplication.properties /config2/application.properties

#COPY watcher.sh .

# Puerto en el que escucha el servicio
EXPOSE 8080

# Instalación de paquetes adicionales
#RUN apk add --no-cache inotify-tools
#RUN apk add --no-cache wget

#microservicio cuando se ejecute el contenedor
CMD ["java", "-jar", "app.jar"]