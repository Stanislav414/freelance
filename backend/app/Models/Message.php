<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Message extends Model
{
    protected $fillable = [
        'chat_id',
        'user_id', // nullable для системных сообщений
        'content',
        'type',
        'status',
        'read_at',
        'is_deleted'
    ];

    protected $casts = [
        'read_at' => 'datetime',
        'is_deleted' => 'boolean',
    ];

    public function chat(): BelongsTo
    {
        return $this->belongsTo(Chat::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    // Проверить, прочитано ли сообщение
    public function isRead(): bool
    {
        return !is_null($this->read_at);
    }

    // Отметить сообщение как прочитанное
    public function markAsRead(): void
    {
        if (!$this->isRead()) {
            $this->update(['read_at' => now()]);
        }
    }
}
