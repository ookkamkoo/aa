# Use PHP 8.2 with FPM as the base image
FROM php:8.2-fpm

# Install necessary PHP extensions and dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    git \
    && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip

# Set the working directory
WORKDIR /var/www

# Copy composer binary from composer image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy the contents of the lumen directory into the container
COPY ./lumen/ /var/www/

# List the contents of /var/www to verify files are copied
RUN ls -la /var/www

# Install PHP dependencies
# RUN composer install --no-dev --optimize-autoloader

# Expose port 9000 and start PHP-FPM server
EXPOSE 9000
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]
