# Step 1: Build the React app
FROM node:18-alpine AS build
WORKDIR /app

# Install build dependencies for native modules
RUN apk add --no-cache python3 make g++

COPY package*.json ./

# The --legacy-peer-deps flag is required to bypass the MUI/React version conflict
RUN npm install --legacy-peer-deps

COPY . .
RUN npm run build

# Step 2: Serve with Nginx
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
