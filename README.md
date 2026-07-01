# Dockerizing a Node.js WebApp + Nginx Proxy Manager
This project shows how I containerized a node.js webapp using Dockerfile and deployed it using Docker Compose with Nginx Proxy Manager as a reverse proxy.


## Create project

```bash id="c1"
mkdir Dockerizing-a-NodeJS-WebApp

cd Dockerizing-a-NodeJS-WebApp
```

## Create node.js server

```bash id="c2"
vim server.js
```
```
import express from "express";
import dotenv from "dotenv";
dotenv.config

const PORT = process.env.PORT || 8080;
const app = express();

app.get("/", (req, res) => {
  res.json({ message: "We have mounted the voulme to running container. Update in the webapp! More updates! " });
});

app.listen(PORT, () => {
  console.log(`App running on ${PORT}`);
});
```

## Create dockerfile

```bash id="c5"
vim Dockerfile
```

```dockerfile id="c6"
FROM node:18-alpine

#create app dir
WORKDIR /app

#install dependencies
COPY package*.json ./

#run npm i
RUN npm install

#bundle app source
COPY . .

EXPOSE 8080

CMD ["npm", "start"]
```

## Build docker image

```bash id="c7"
docker build -t nodejs-webapp:v1 .
docker image ls
```

<img width="1393" height="122" alt="image" src="https://github.com/user-attachments/assets/f962f425-126f-46af-8c01-e9896123f67e" />

## Run container for testing

```bash id="c8"
docker run -dp 8080:8080 --name nodejs nodejs-webapp:v1
docker ps
```
<img width="1896" height="239" alt="image" src="https://github.com/user-attachments/assets/ac2e4a59-78c2-4a03-b379-8546f112af64" />

## Stop and rm after testing

```bash id="c10"
docker stop nodejs
docker rm nodejs
docker rmi nodejs-webapp:v1
```

## Create docker compose file

```bash id="c11"
vim compose.yaml
```

```yaml id="c12"
services:
  nginx-pm:
    image: 'jc21/nginx-proxy-manager:2.15.1'
    restart: unless-stopped

    ports:
      - '80:80' # Public HTTP Port
      - '443:443' # Public HTTPS Port
      - '81:81' # Admin Web Port

    environment:
      TZ: "Asia/Karachi"

    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt

    networks:
      - web

  nodejs-webapp:
    build: .
    restart: unless-stopped

    expose: 
      - "8080"

    networks:
      - web

networks:
    web:
      name: web
```

## Deploy

```bash id="c13"
docker compose up -d --build
docker ps
docker network ls
```
<img width="1544" height="262" alt="image" src="https://github.com/user-attachments/assets/2c8be657-c1f3-4f1e-8956-30e3e5451e96" />

<img width="1920" height="958" alt="image" src="https://github.com/user-attachments/assets/19094e41-195e-41c1-8fd3-a2f98e4246ef" />

## Create .dockerignore and .gitignore

```bash id="c3"
vim .dockerignore
vim .gitignore
```

```text id="c4"
node_modules
data
letsencrypt
```

## Add local domain

```bash id="c14"
sudo vim /etc/hosts
```

```text id="c15"
127.0.0.1 nodejs-webapp.local
```

<img width="1248" height="301" alt="image" src="https://github.com/user-attachments/assets/a6b11083-8d90-4c87-9d5b-1cb258e8cdb5" />

```bash id="c16"
ping nodejs-webapp.local
```

<img width="1111" height="364" alt="image" src="https://github.com/user-attachments/assets/d193d1c7-b7df-42ae-bf4a-a4dd440cbcb0" />

## Rebuilding after updates

```bash id="c18"
docker compose up -d --build
```

<img width="1731" height="834" alt="image" src="https://github.com/user-attachments/assets/f0587ba0-8b18-4932-92f3-3e36750c77a0" />

## What I learned

* Containerizing a Node.js webapp using Dockerfile
* Debugging with docker exec, ss, and ps
* Multi container setup using Docker Compose
* Docker networking
* Reverse proxy setup using Nginx Proxy Manager
* Local domain mapping



