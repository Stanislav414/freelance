<?php

return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    // Для production укажите конкретные домены фронтенда, например: 'https://254091.xorek.cloud'
    'allowed_origins' => env('CORS_ALLOWED_ORIGINS') ? explode(',', env('CORS_ALLOWED_ORIGINS')) : ['*'],
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    // Используем Bearer-токены, поэтому креденшелы (cookie) не требуются
    'supports_credentials' => false,
];
