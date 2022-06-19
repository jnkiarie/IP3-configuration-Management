FROM mongo-express

RUN mkdir /backend

WORKDIR /backend

COPY package-lock.json /backend/

COPY package.json /backend/

RUN npm install

COPY . .

CMD ["npm","start"]