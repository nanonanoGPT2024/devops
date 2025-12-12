FROM node:18

WORKDIR /app

COPY  package.json .

run npm install

COPY . .

EXPOSE 3000

CMD ["node", "app.js"]

