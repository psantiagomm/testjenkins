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
FROM amazoncorretto:21

VOLUME /tmptestjenkins

WORKDIR /app/

# Copia el archivo JAR al contenedor
COPY --from=build /app/target/*.jar /app/app.jar

# Puerto en el que escucha el servicio
EXPOSE 8080

#microservicio cuando se ejecute el contenedor
CMD ["java", "-jar", "app.jar"]