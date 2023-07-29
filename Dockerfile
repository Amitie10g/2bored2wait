FROM node:alpine AS download

LABEL maintainer="mrgeorgen"
LABEL name="2bored2wait"

# copy application
COPY . "/srv/app"
WORKDIR "/srv/app"

# remove comments from config/default.json
RUN sed -i 's/\/\/.*$//' config/default.json

# install requirements
RUN npm install --omit=dev && \
    npm install modclean -g && \
    modclean --run --patterns="default:*"

# Use a fresh container just with node_modules
FROM node:alpine

COPY --from=download /srv/app /srv/app
WORKDIR "/srv/app"

# exposing 8080 (webui), 25566 (mc proxy)
EXPOSE 8080/tcp
EXPOSE 25565/tcp

# run container
CMD npm start
