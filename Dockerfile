FROM node:18.18.2-alpine as builder
WORKDIR /app
COPY ./package.json .
COPY ./yarn.lock .
RUN yarn install
COPY . .

FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]
