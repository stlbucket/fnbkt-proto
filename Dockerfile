FROM node:18-alpine3.17 as build

# update and install the latest dependencies for the alpine version
RUN apk update && apk upgrade

# set work dir as app
WORKDIR /app
# copy the nuxt project package json and package json lock if available 
COPY package* ./
# install all the project npm dependencies
RUN  npm install
# copy all other project files to working directory
COPY . ./
# build the nuxt project to generate the artifacts in .output directory
RUN npx nuxt build

# we are using multi stage build process to keep the image size as small as possible
FROM node:18-alpine3.17
# update and install latest dependencies, add dumb-init package
# add a non root user
RUN apk update && apk upgrade && apk add dumb-init && adduser -D nuxtuser 
# set non root user
USER nuxtuser

# set work dir as app
WORKDIR /app
# copy the output directory to the /app directory from 
# build stage with proper permissions for user nuxt user
COPY --chown=nuxtuser:nuxtuser --from=build /app/.output ./
# expose 8080 on container
EXPOSE 8080

# set app host and port . In nuxt 3 this is based on nitro and you can read
#more on this https://nitro.unjs.io/deploy/node#environment-variables
ENV HOST=0.0.0.0 PORT=8080 NODE_ENV=production
ENV SUPABASE_URL=$SUPABASE_URL
ENV SUPABASE_KEY=$SUPABASE_KEY
ENV SUPABASE_SERVICE_KEY=$SUPABASE_SERVICE_KEY
ENV SUPABASE_JWT_SECRET=$SUPABASE_JWT_SECRET
ENV SUPABASE_URI=$SUPABASE_URI

# start the app with dumb init to spawn the Node.js runtime process
# with signal support
CMD ["dumb-init","node","/app/server/index.mjs"]




# # https://codelabs.developers.google.com/codelabs/cloud-run-hello/#3

# # use node 16 alpine image
# FROM node:18-alpine

# # create work directory in app folder
# WORKDIR /app

# # install required packages for node image
# RUN apk --no-cache add openssh g++ make python3 git

# # copy over package.json files
# COPY package.json /app/
# COPY package-lock.json /app/

# # install all depencies
# # RUN npm ci && npm cache clean --force
# RUN npm i

# # copy over all files to the work directory
# ADD . /app

# # build the project
# RUN npm run build

# # expose the host and port 3000 to the server
# ENV HOST 0.0.0.0
# ENV PORT 8080
# # EXPOSE 3000
# ENV SUPABASE_URL=$SUPABASE_URL
# ENV SUPABASE_KEY=$SUPABASE_KEY
# ENV SUPABASE_SERVICE_KEY=$SUPABASE_SERVICE_KEY
# ENV SUPABASE_JWT_SECRET=$SUPABASE_JWT_SECRET
# ENV SUPABASE_URI=$SUPABASE_URI

# # run the build project with node
# ENTRYPOINT ["node", ".output/server/index.mjs"]
