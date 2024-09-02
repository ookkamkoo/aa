FROM php:8.2-fpm

# ติดตั้ง PHP extensions และ dependencies ที่จำเป็น
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

# ตั้งค่า working directory
WORKDIR /var/www

# คัดลอกไฟล์ composer จาก image ของ composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# คัดลอกไฟล์จาก context (ที่โฟลเดอร์ที่ Dockerfile ตั้งอยู่)
COPY ./lumen/ /var/www/

# ตรวจสอบไฟล์ที่ถูกคัดลอก
RUN ls -la /var/www

# ติดตั้ง PHP dependencies
RUN ls -la /var/www && composer install --no-dev --optimize-autoloader

# เปิดพอร์ต 9000 และเริ่ม PHP-FPM server
EXPOSE 9000
CMD ["php-fpm"]