# ---------- Build Stage ----------
FROM node:12-alpine AS build-stage

# Установка рабочей директории
WORKDIR /app

# Копируем package.json и package-lock.json
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем остальные файлы в контейнер
COPY . .

# Сборка фронтенда
RUN npm run build

# ---------- Production Stage ----------
FROM nginx:1.25-alpine AS production-stage

# Удаляем стандартную конфигурацию nginx
RUN rm /etc/nginx/conf.d/default.conf

# Копируем собранный фронтенд из предыдущего этапа
COPY --from=build-stage /app/dist/frontend/ /usr/share/nginx/html/

# Копируем кастомный конфиг nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Открываем порт
EXPOSE 80

# Запускаем nginx в режиме демона
CMD ["nginx", "-g", "daemon off;"]
