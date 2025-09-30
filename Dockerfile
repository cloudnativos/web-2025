# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache \
    hugo \
    make \
    python3 \
    py3-setuptools \
    build-base \
    git

# Copy package files first for better layer caching
COPY package.json package-lock.json ./

# Install npm dependencies
RUN npm ci --only=production

# Copy configuration files
COPY .gitmodules config.toml icons.js Makefile postcss.config.js ./

# Initialize git and update submodules
RUN git init && \
    git config --global --add safe.directory /app && \
    git submodule update -f --init --recursive

# Copy application files
COPY archetypes archetypes
COPY content content
COPY data data
COPY i18n i18n
COPY layouts layouts
COPY static static
COPY themes themes

# Runtime stage
FROM node:20-alpine

WORKDIR /app

# Install only hugo (runtime dependency)
RUN apk add --no-cache hugo

# Copy only necessary files from builder
COPY --from=builder --chown=node:node /app /app

# Switch to non-root user
USER node

# Expose default Hugo port
EXPOSE 1313

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:1313/ || exit 1

# Set entrypoint and default command
ENTRYPOINT ["hugo"]
CMD ["server", "--disableLiveReload", "--bind", "0.0.0.0"]
