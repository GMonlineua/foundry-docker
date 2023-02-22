FROM node:current-alpine3.16 
WORKDIR /usr/src/app 
COPY foundryvtt/ ./ 
CMD ["node", "resources/app/main.js", "--dataPath=/home/node"]
