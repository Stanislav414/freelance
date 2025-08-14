<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class AddHeaders
{
    public function handle(Request $request, Closure $next)
    {
        // Добавляем заголовок в запрос для пропуска предупреждения ngrok
        $request->headers->set('ngrok-skip-browser-warning', 'true');
        
        return $next($request);
    }
}
