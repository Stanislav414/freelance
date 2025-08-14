<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

// SPA fallback - отдаем index.html для всех маршрутов, кроме API
Route::get('/{any}', function () {
    return view('welcome');
})->where('any', '.*');
