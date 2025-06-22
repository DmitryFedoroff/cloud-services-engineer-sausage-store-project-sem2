# ---------- Build Stage ----------
ARG VERSION=0.1.0-SNAPSHOT

FROM maven:3.8.2-openjdk-16-slim AS builder
ARG VERSION

# Устанавливаем рабочую директорию
WORKDIR /usr/src/app

# Копируем файл зависимостей и загружаем их
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Копируем исходный код
COPY ./src ./src

# Сборка проекта без тестов и переименование JAR-файла
RUN mvn clean package -DskipTests -DVERSION=${VERSION} \
    && cp target/sausage-store-${VERSION}.jar target/sausage-store.jar

# ---------- Production Stage ----------
FROM amazoncorretto:17-alpine

# Создаем рабочую директорию приложения
WORKDIR /app

# Создаем системного пользователя
RUN addgroup --system jaruser \
    && adduser -S -s /bin/false -G jaruser jaruser -D -H \
    && apk add --no-cache dumb-init curl netcat-openbsd \
    && mkdir -p /logs/reports \
    && chown -R jaruser:jaruser /logs

# Копируем JAR с правильными правами доступа
COPY --chown=jaruser:jaruser --from=builder /usr/src/app/target/sausage-store.jar ./sausage-store.jar

# Открываем порт
EXPOSE 8080

# Запускаем от имени jaruser
USER jaruser

# Конфигурация healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

# Запуск приложения с dumb-init
ENTRYPOINT ["dumb-init", "java", "-jar", "-Dmyserver.bindPort=8080", "./sausage-store.jar"]
