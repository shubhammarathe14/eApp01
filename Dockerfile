# Stage 1: Build the Angular Application

FROM node:18 AS build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install --legacy-peer-deps

COPY . .
RUN npm run build -- --configuration=production --output-path=dist/angular-ecom-main

# Stage 2: 

FROM node:18-slim

WORKDIR /app

RUN npm install -g json-server serve


COPY --from=build /app/dist/angular-ecom-main /app


COPY db.json /app/db.json

EXPOSE 80 3000

CMD ["sh", "-c", "serve -s /app -l 80 & json-server --watch /app/db.json --port 3000"]
