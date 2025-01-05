# Use a lightweight base image
FROM alpine:3.18

# Install dependencies and kubectl manually
RUN apk add --no-cache \
    bash \
    curl \
    jq \
    && rm -rf /var/cache/apk/* \
    && curl -LO https://dl.k8s.io/release/v1.26.0/bin/linux/amd64/kubectl \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

# Add the script to the image
COPY check-namespaces.sh /usr/local/bin/check-namespaces.sh

# Make the script executable
RUN chmod +x /usr/local/bin/check-namespaces.sh

# Set the entrypoint to the script
ENTRYPOINT ["/usr/local/bin/check-namespaces.sh"]
