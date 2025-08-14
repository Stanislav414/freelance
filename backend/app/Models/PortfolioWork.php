<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class PortfolioWork extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'title',
        'description',
        'specialization',
        'url',
        'image',
        'is_featured',
        'sort_order',
    ];

    protected $casts = [
        'is_featured' => 'boolean',
        'sort_order' => 'integer',
    ];

    /**
     * Связь с пользователем (исполнителем)
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Scope для получения работ пользователя
     */
    public function scopeForUser($query, $userId)
    {
        return $query->where('user_id', $userId);
    }

    /**
     * Scope для получения рекомендуемых работ
     */
    public function scopeFeatured($query)
    {
        return $query->where('is_featured', true);
    }

    /**
     * Scope для сортировки по порядку
     */
    public function scopeOrdered($query)
    {
        return $query->orderBy('sort_order')->orderBy('created_at', 'desc');
    }

    /**
     * Получить URL полного изображения
     */
    public function getImageUrlAttribute()
    {
        if (!$this->image) {
            return null;
        }

        // Если уже полный URL
        if (str_starts_with($this->image, 'http')) {
            return $this->image;
        }

        // Относительный путь от storage
        return asset('storage/' . $this->image);
    }

    /**
     * Получить название типа работы
     */
    public function getSpecializationNameAttribute()
    {
        $types = [
            'video' => 'Видео',
            'color_correction' => 'Цветокоррекция',
            'motion_design' => 'Моушн-дизайн',
            'video_editing' => 'Монтаж видео',
            'graphic_design' => 'Графический дизайн',
            'logo_design' => 'Дизайн логотипов',
            'branding' => 'Брендинг',
            'presentation' => 'Презентации',
            'advertising' => 'Рекламные макеты',
            'social_media' => 'Контент для соцсетей',
            'mp_card_design' => 'Дизайн карточки для МП',
            'business_card_design' => 'Дизайн визитки',
        ];

        return $types[$this->specialization] ?? $this->specialization ?? 'Другое';
    }
}