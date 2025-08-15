#!/bin/bash

echo "🚀 Начинаем обновление проекта..."

# Переходим в директорию проекта
cd /var/www/freelance

# Обновляем код
echo "📥 Обновляем код из Git..."
sudo git pull origin main

# Обновляем бэкенд
echo "🔧 Обновляем Laravel..."
cd backend
composer install --no-dev --optimize-autoloader
php artisan migrate --force
php artisan config:cache

# Обновляем фронтенд
echo "🎨 Собираем фронтенд..."
cd ../frontend
npm ci
npm run build

# Устанавливаем права
echo "🔐 Устанавливаем права доступа..."
sudo chown -R www-data:www-data /var/www/freelance
sudo chmod -R 775 /var/www/freelance/backend/storage
sudo chmod -R 775 /var/www/freelance/backend/bootstrap/cache

# Перезагружаем Nginx
echo "🔄 Перезагружаем Nginx..."
sudo systemctl reload nginx

echo "✅ Обновление завершено!"
echo "🌐 Сайт доступен по адресу: http://136.0.133.87"
