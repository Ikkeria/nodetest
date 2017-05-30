FROM node:7.10.0

RUN mkdir -p /usr/src/app
COPY package.json /usr/src/app/
COPY app.js /usr/src/app/
COPY *.pem /usr/src/app/


WORKDIR /usr/src/app
RUN npm install

EXPOSE 8080
CMD [ "npm", "start" ]