<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Carbon\Carbon;

class PasswordResetController extends Controller
{
    /**
     * Отправить код восстановления на email
     */
    public function sendResetCode(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:users,email'
        ]);

        $email = $request->email;
        
        // Генерируем 6-значный код
        $code = str_pad(random_int(0, 999999), 6, '0', STR_PAD_LEFT);
        
        // Сохраняем код в базе данных
        DB::table('password_reset_codes')->updateOrInsert(
            ['email' => $email],
            [
                'code' => Hash::make($code),
                'created_at' => now(),
                'expires_at' => now()->addMinutes(10) // Код действителен 10 минут
            ]
        );

        // Отправляем email с кодом
        try {
            Mail::send('emails.password-reset', ['code' => $code], function($message) use ($email) {
                $message->to($email)
                        ->subject('Восстановление пароля - SuriTask')
                        ->from(config('mail.from.address'), config('mail.from.name'));
            });

            return response()->json([
                'message' => 'Код восстановления отправлен на ваш email'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Ошибка отправки email. Попробуйте позже.'
            ], 500);
        }
    }

    /**
     * Проверить код и сбросить пароль
     */
    public function resetPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:users,email',
            'code' => 'required|string|size:6',
            'password' => 'required|string|min:8|confirmed'
        ]);

        $email = $request->email;
        $code = $request->code;
        $password = $request->password;

        // Проверяем код
        $resetRecord = DB::table('password_reset_codes')
            ->where('email', $email)
            ->where('expires_at', '>', now())
            ->first();

        if (!$resetRecord || !Hash::check($code, $resetRecord->code)) {
            return response()->json([
                'message' => 'Неверный код или код истек'
            ], 400);
        }

        // Обновляем пароль
        User::where('email', $email)->update([
            'password' => Hash::make($password)
        ]);

        // Удаляем использованный код
        DB::table('password_reset_codes')->where('email', $email)->delete();

        return response()->json([
            'message' => 'Пароль успешно изменен'
        ]);
    }

    /**
     * Проверить валидность кода (для фронтенда)
     */
    public function verifyCode(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:users,email',
            'code' => 'required|string|size:6'
        ]);

        $email = $request->email;
        $code = $request->code;

        $resetRecord = DB::table('password_reset_codes')
            ->where('email', $email)
            ->where('expires_at', '>', now())
            ->first();

        if (!$resetRecord || !Hash::check($code, $resetRecord->code)) {
            return response()->json([
                'valid' => false,
                'message' => 'Неверный код или код истек'
            ], 400);
        }

        return response()->json([
            'valid' => true,
            'message' => 'Код верный'
        ]);
    }

    /**
     * Проверить сложность пароля
     */
    public function validatePassword(Request $request)
    {
        $request->validate([
            'password' => 'required|string'
        ]);

        $password = $request->password;
        $errors = [];
        $strength = 0;

        // Проверка длины
        if (strlen($password) < 8) {
            $errors[] = 'Пароль должен содержать минимум 8 символов';
        } else {
            $strength += 1;
        }

        // Проверка наличия букв
        if (!preg_match('/[a-zA-Z]/', $password)) {
            $errors[] = 'Пароль должен содержать буквы';
        } else {
            $strength += 1;
        }

        // Проверка наличия цифр
        if (!preg_match('/[0-9]/', $password)) {
            $errors[] = 'Пароль должен содержать цифры';
        } else {
            $strength += 1;
        }

        // Проверка наличия специальных символов
        if (!preg_match('/[!@#$%^&*()_+\-=\[\]{};\':"\\|,.<>\/?]/', $password)) {
            $errors[] = 'Пароль должен содержать специальные символы (!@#$%^&* и т.д.)';
        } else {
            $strength += 1;
        }

        // Проверка наличия заглавных букв
        if (!preg_match('/[A-Z]/', $password)) {
            $errors[] = 'Пароль должен содержать заглавные буквы';
        } else {
            $strength += 1;
        }

        // Определение силы пароля
        $strengthText = '';
        $strengthColor = '';
        
        if ($strength <= 2) {
            $strengthText = 'Слабый';
            $strengthColor = 'red';
        } elseif ($strength <= 3) {
            $strengthText = 'Средний';
            $strengthColor = 'yellow';
        } elseif ($strength <= 4) {
            $strengthText = 'Хороший';
            $strengthColor = 'blue';
        } else {
            $strengthText = 'Отличный';
            $strengthColor = 'green';
        }

        return response()->json([
            'valid' => empty($errors),
            'errors' => $errors,
            'strength' => $strength,
            'strengthText' => $strengthText,
            'strengthColor' => $strengthColor
        ]);
    }
}
