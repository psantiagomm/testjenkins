# Etapa de construcción
FROM maven:3.9.8-amazoncorretto-21 AS build

WORKDIR /app/

COPY ../pom.xml ./
RUN mkdir -p /root/.m2 && mvn -B dependency:resolve

# Copiar el código fuente de la aplicación
COPY ../src ./src

RUN mvn -B package -DskipTests

# Etapa de ejecución
# Imagen base de Java
FROM amazoncorretto:22-alpine

RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

VOLUME /tmp

WORKDIR /app

# Establecer la codificación por defecto en UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV JAVA_OPTS="-Dfile.encoding=UTF-8"

COPY --from=build /app/target/*.jar /app/app.jar

#COPY watcher.sh .

# Puerto en el que escucha el servicio
EXPOSE 8080

# Instalación de paquetes adicionales
#RUN apk add --no-cache inotify-tools
#RUN apk add --no-cache wget

#microservicio cuando se ejecute el contenedor
CMD ["java", "-Dfile.encoding=UTF-8", "-jar", "app.jar"]