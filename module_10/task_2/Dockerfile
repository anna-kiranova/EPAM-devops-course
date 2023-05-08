FROM node:20-alpine3.16

COPY . .

# Install app dependencies
RUN npm install

# Creates a "dist" folder with the production build
RUN npm run build

# Start the server using the production build
CMD [ "node", "dist/main.js" ]
