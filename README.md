# Dockerizing Node.js App + Nginx Proxy Manager

---

## Create Project

```bash id="c1"
cd repos/
mkdir Dockerizing-a-NodeJS-WebApp
cd Dockerizing-a-NodeJS-WebApp
```

---
## Create Node.js Server

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

---

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

---

## Create Dockerfile

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

---

## Build Docker Image

```bash id="c7"
docker build -t nodejs-webapp:v1 .
docker image ls
```

---

## Run Container for testing

```bash id="c8"
docker run -dp 8080:8080 --name nodejs nodejs-webapp:v1
docker ps
```

---

## Debug Running Container

```bash id="c9"
docker exec -it nodejs sh
ss -tulpn
ps aux
```

---

## Stop and Cleanup

```bash id="c10"
docker stop nodejs
docker rm nodejs
docker rmi nodejs-webapp:v1
```

---

## Create Docker Compose

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

---

## Deploy

```bash id="c13"
docker compose up -d --build
docker ps
docker network ls
```
---

## Add Local Domain Mapping

```bash id="c14"
sudo vim /etc/hosts
```

```text id="c15"
127.0.0.1 nodejs-webapp.local
```

```bash id="c16"
ping nodejs-webapp.local
```
---

---

## Rebuilding after updates

```bash id="c18"
docker compose up -d --build
```
---


