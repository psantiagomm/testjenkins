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

# Añadir el repositorio de glibc y la clave pública
RUN apk --no-cache add \
    wget \
    gnupg \
    && wget -O /etc/apk/keys/sgerrand.rsa.pub \
    https://github.com/sgerrand/alpine-pkg-glibc/releases/download/20210816-r0/sgerrand.rsa.pub \
    && wget -O glibc-2.33-r0.apk \
    https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.33-r0/glibc-2.33-r0.apk \
    && apk add --no-cache glibc-2.33-r0.apk \
    && rm glibc-2.33-r0.apk \
    && wget -O glibc-bin-2.33-r0.apk \
    https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.33-r0/glibc-bin-2.33-r0.apk \
    && apk add --no-cache glibc-bin-2.33-r0.apk \
    && rm glibc-bin-2.33-r0.apk \
    && wget -O glibc-i18n-2.33-r0.apk \
    https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.33-r0/glibc-i18n-2.33-r0.apk \
    && apk add --no-cache glibc-i18n-2.33-r0.apk \
    && rm glibc-i18n-2.33-r0.apk

# Instalar 'file' para herramientas adicionales si es necesario
RUN apk update && apk add --no-cache file

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