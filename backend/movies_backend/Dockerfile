FROM php:8.2-apache

# Install PDO MySQL extension
RUN docker-php-ext-install pdo pdo_mysql

# Copy your backend files into the container
COPY . /var/www/html/

# Ensure Apache is listening on port 80
EXPOSE 80