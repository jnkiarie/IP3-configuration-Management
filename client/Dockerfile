FROM node:14-alpine

RUN mkdir /client

WORKDIR /client

COPY . .

# RUN npm i npm@latest -g

RUN npm install

RUN npm install webpack

EXPOSE 3000

CMD ["npm","start"]