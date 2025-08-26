# Настройка Email для восстановления пароля

## 🔧 Настройка корпоративной почты

Для работы системы восстановления пароля необходимо настроить отправку email через вашу корпоративную почту.

### 1. Настройка .env файла

Добавьте следующие настройки в файл `backend/.env`:

```env
# Email настройки
MAIL_MAILER=smtp
MAIL_HOST=smtp.your-domain.com
MAIL_PORT=587
MAIL_USERNAME=your-email@your-domain.com
MAIL_PASSWORD=your-email-password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=your-email@your-domain.com
MAIL_FROM_NAME="SuriTask"
```

### 2. Примеры настроек для популярных почтовых сервисов

#### Gmail (Google Workspace)
```env
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=your-email@gmail.com
MAIL_FROM_NAME="SuriTask"
```

#### Yandex
```env
MAIL_MAILER=smtp
MAIL_HOST=smtp.yandex.ru
MAIL_PORT=587
MAIL_USERNAME=your-email@yandex.ru
MAIL_PASSWORD=your-app-password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=your-email@yandex.ru
MAIL_FROM_NAME="SuriTask"
```

#### Mail.ru
```env
MAIL_MAILER=smtp
MAIL_HOST=smtp.mail.ru
MAIL_PORT=587
MAIL_USERNAME=your-email@mail.ru
MAIL_PASSWORD=your-app-password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=your-email@mail.ru
MAIL_FROM_NAME="SuriTask"
```

### 3. Настройка пароля приложения

Для Gmail и других сервисов может потребоваться создать пароль приложения:

1. **Gmail**: Настройки аккаунта → Безопасность → Пароли приложений
2. **Yandex**: Настройки → Безопасность → Пароли для почтовых клиентов
3. **Mail.ru**: Настройки → Безопасность → Пароли для внешних приложений

### 4. Тестирование отправки

После настройки можно протестировать отправку email:

```bash
php artisan tinker
```

```php
Mail::raw('Тестовое письмо', function($message) {
    $message->to('test@example.com')
            ->subject('Тест SuriTask')
            ->from(config('mail.from.address'), config('mail.from.name'));
});
```

### 5. Безопасность

- ✅ Используйте пароли приложений вместо обычных паролей
- ✅ Включите двухфакторную аутентификацию
- ✅ Регулярно обновляйте пароли
- ✅ Используйте HTTPS для защиты данных

### 6. Альтернативные решения

Если возникают проблемы с SMTP, можно использовать:

#### Mailgun
```env
MAIL_MAILER=mailgun
MAILGUN_DOMAIN=your-domain.com
MAILGUN_SECRET=your-mailgun-secret
```

#### SendGrid
```env
MAIL_MAILER=smtp
MAIL_HOST=smtp.sendgrid.net
MAIL_PORT=587
MAIL_USERNAME=apikey
MAIL_PASSWORD=your-sendgrid-api-key
MAIL_ENCRYPTION=tls
```

### 7. Логирование для отладки

Для отладки проблем с отправкой добавьте в `.env`:

```env
MAIL_LOG_CHANNEL=mail
```

И создайте канал в `config/logging.php`:

```php
'channels' => [
    'mail' => [
        'driver' => 'single',
        'path' => storage_path('logs/mail.log'),
        'level' => 'debug',
    ],
],
```

## 🚀 Готово!

После настройки email система восстановления пароля будет работать следующим образом:

1. Пользователь вводит email на странице восстановления
2. Система отправляет 6-значный код на указанный email
3. Пользователь вводит код в форму
4. После подтверждения кода пользователь может установить новый пароль
5. Код действителен 10 минут и может быть отправлен повторно через 60 секунд
