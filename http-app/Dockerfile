FROM node:7.10.0

RUN mkdir -p /usr/src/app/
COPY src/* /usr/src/app/

WORKDIR /usr/src/app/

EXPOSE 80
CMD [ "npm", "start" ]