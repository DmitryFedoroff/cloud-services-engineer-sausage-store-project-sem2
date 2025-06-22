# ---------- Build Stage ----------
FROM golang:1.20-alpine AS builder

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем модули и загружаем зависимости
COPY go.mod go.sum ./
RUN go mod download

# Копируем исходники и собираем бинарник
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# ---------- Runtime Stage ----------
FROM alpine:latest

# Устанавливаем необходимые зависимости
RUN apk --no-cache add ca-certificates curl

# Создаем рабочую директорию
WORKDIR /root/

# Копируем собранное приложение из builder-стадии
COPY --from=builder /app/main .

# Открываем порт
EXPOSE 8080

# Конфигурация проверки работоспособности
HEALTHCHECK --interval=30s --timeout=3s --start-period=20s --retries=3 \
  CMD curl -f http://localhost:8080/api/v1/health || exit 1

# Запуск приложения
CMD ["./main"]
