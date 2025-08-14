<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Review extends Model
{
    protected $fillable = [
        'order_id',
        'reviewer_id',
        'reviewed_id',
        'rating',
        'text',
        'is_public'
    ];

    protected $casts = [
        'rating' => 'integer',
        'is_public' => 'boolean',
    ];

    /**
     * Заказ, к которому относится отзыв
     */
    public function order(): BelongsTo
    {
        return $this->belongsTo(Order::class);
    }

    /**
     * Пользователь, который оставил отзыв
     */
    public function reviewer(): BelongsTo
    {
        return $this->belongsTo(User::class, 'reviewer_id');
    }

    /**
     * Пользователь, о котором отзыв
     */
    public function reviewed(): BelongsTo
    {
        return $this->belongsTo(User::class, 'reviewed_id');
    }
}
