# Use lightweight Nginx image
FROM nginx:alpine

# Copy your app files
COPY index.html /usr/share/nginx/html/index.html

# Expose HTTP port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
