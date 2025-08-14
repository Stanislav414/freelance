<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Chat extends Model
{
    protected $fillable = [
        'order_id',
        'title',
        'category',
        'is_active'
    ];

    protected $casts = [
        'is_active' => 'boolean',
    ];

    public function order(): BelongsTo
    {
        return $this->belongsTo(Order::class);
    }

    public function participants(): HasMany
    {
        return $this->hasMany(ChatParticipant::class);
    }

    public function messages(): HasMany
    {
        return $this->hasMany(Message::class);
    }

    public function users()
    {
        return $this->belongsToMany(User::class, 'chat_participants')
                    ->withPivot('role', 'last_read_at')
                    ->withTimestamps();
    }

    // Получить последнее сообщение в чате
    public function lastMessage()
    {
        return $this->hasOne(Message::class)->latest();
    }

    // Получить количество непрочитанных сообщений для пользователя
    public function unreadCount($userId)
    {
        $participant = $this->participants->firstWhere('user_id', $userId) ??
            $this->participants()->where('user_id', $userId)->first();
        if (!$participant) {
            return 0;
        }
        
        // Если пользователь еще не читал сообщения, считаем все сообщения от других пользователей
        if (!$participant->last_read_at) {
            return $this->messages()
                       ->where('user_id', '!=', $userId)
                       ->count();
        }
        
        // Считаем только сообщения от других пользователей после последнего прочтения
        return $this->messages()
                   ->where('user_id', '!=', $userId)
                   ->where('created_at', '>', $participant->last_read_at)
                   ->count();
    }
}
