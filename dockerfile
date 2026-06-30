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
