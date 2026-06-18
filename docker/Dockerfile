# syntax=docker/dockerfile:1.7
# Railway root Dockerfile — cache bust comment

# Stage 1: Build the frontend with TypeScript + Vite.
FROM node:20-alpine AS builder

WORKDIR /app

# Pre-install blog-site dependencies so the postinstall script succeeds.
# postinstall runs: cd blog-site && npm ci --prefer-offline
COPY blog-site/package.json blog-site/package-lock.json ./blog-site/
RUN cd blog-site && npm ci

# Install root dependencies — postinstall finds blog-site/node_modules already in place.
COPY package.json package-lock.json ./
RUN npm ci --include=dev

# Copy source and build.
COPY . .

ARG VITE_VARIANT=full
ARG VITE_WS_API_URL=https://api.worldmonitor.app
ENV VITE_VARIANT=${VITE_VARIANT}
ENV VITE_WS_API_URL=${VITE_WS_API_URL}

RUN npm run build


# Stage 2: Serve built assets from nginx.
FROM nginx:alpine AS runtime

WORKDIR /usr/share/nginx/html

ENV API_UPSTREAM=https://api.worldmonitor.app

COPY --from=builder /app/dist/ ./
COPY docker/nginx.conf.template /etc/nginx/nginx.conf.template
COPY docker/nginx-security-headers.conf /etc/nginx/security_headers.conf
COPY docker/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 8080

CMD ["/docker-entrypoint.sh"]
