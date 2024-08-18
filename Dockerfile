FROM node:18-alpine

RUN sed -i 's|http://dl-cdn.alpinelinux.org|http://dl-5.alpinelinux.org|g' /etc/apk/repositories

# Installing libvips-dev for sharp Compatibility
RUN apk update 
RUN apk add --no-cache build-base 
RUN apk add --no-cache gcc 
RUN apk add --no-cache autoconf automake 
RUN apk add --no-cache zlib-dev libpng-dev nasm bash vips-dev git
ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/
COPY package.json package-lock.json ./
RUN npm install -g node-gyp
RUN npm config set fetch-retry-maxtimeout 600000 -g && npm install
ENV PATH=/opt/node_modules/.bin:$PATH

WORKDIR /opt/app
COPY . .
RUN chown -R node:node /opt/app
USER node
RUN ["npm", "run", "build"]
EXPOSE 1337
CMD ["npm", "run", "develop"]