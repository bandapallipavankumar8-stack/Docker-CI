# Step 1: Use the official lightweight Alpine Nginx image
FROM nginx:alpine

# Step 2: Copy your local website files into Nginx's default folder
COPY /usr/share/nginx/html

# Step 3: Inform Docker that the container will listen on port 80
EXPOSE 80

# Step 4: Keep Nginx running in the foreground so the container doesn't exit
CMD ["nginx", "-g", "daemon off;"]
