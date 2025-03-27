FROM node:23-alpine3.21 as build
WORKDIR /app
COPY package*.json ./
RUN apk update && \
    apk upgrade && \
    apk add --no-cache libexpat=2.7.0-r0 \
    libxml2=2.13.4-r5 \
    libxslt=1.1.42-r2
RUN npm ci
COPY . .
RUN npm run build

#production environment
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
