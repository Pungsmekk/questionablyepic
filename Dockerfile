# Step 1: Build the React app
FROM node:18-alpine AS build

# Add build tools
RUN apk add --no-cache python3 make g++

WORKDIR /app
COPY package*.json ./

# Install dependencies
RUN npm install --legacy-peer-deps

COPY . .

# THE FIX: This forces the app to use relative paths instead of /live/
RUN PUBLIC_URL=. npm run build

# Step 2: Serve with Nginx
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
