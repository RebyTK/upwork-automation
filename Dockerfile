# Dockerfile for n8n with custom configuration
FROM n8nio/n8n:latest

# Set working directory
WORKDIR /home/node

# Install additional dependencies if needed
USER root
RUN apk add --no-cache curl wget

# Switch back to node user
USER node

# Expose n8n port
EXPOSE 5678

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:5678/healthz || exit 1

# Default command
CMD ["n8n", "start"]
