<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    // Константы статусов
    const STATUS_OPEN = 'open';
    const STATUS_PENDING_APPROVAL = 'pending_approval';
    const STATUS_IN_PROGRESS = 'in_progress';
    const STATUS_PENDING_REVIEW = 'pending_review';
    const STATUS_REVISION = 'revision';
    const STATUS_COMPLETED = 'completed';
    const STATUS_CANCELLED = 'cancelled';
    const STATUS_DISPUTED = 'disputed';

    protected $fillable = [
        'user_id', 'work_type_id', 'executor_id', 'title', 'description', 'budget', 'deadline', 'status', 'work_link', 'type', 'goal', 'platform', 'format', 'orientation', 'sound', 'executor_offers', 'was_created_without_executor',
        'selected_tariff_id', 'selected_services', 'selected_options', 'calculated_price', 'slides_quantity', 'revision_count'
    ];

    protected $casts = [
        'executor_offers' => 'array',
        'selected_services' => 'array',
        'selected_options' => 'array',
        'calculated_price' => 'decimal:2',
    ];

    public function workType()
    {
        return $this->belongsTo(WorkType::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function executor()
    {
        return $this->belongsTo(User::class, 'executor_id');
    }

    public function attributes()
    {
        return $this->hasMany(OrderAttribute::class);
    }

    public function materials()
    {
        return $this->hasMany(OrderMaterial::class);
    }

    public function selectedTariff()
    {
        return $this->belongsTo(Tariff::class, 'selected_tariff_id');
    }

    public function chat()
    {
        return $this->hasOne(Chat::class);
    }

    /**
     * Отзыв от заказчика на исполнителя
     */
    public function customerReview(): \Illuminate\Database\Eloquent\Relations\HasOne
    {
        return $this->hasOne(Review::class, 'order_id')
            ->where('reviewer_id', $this->user_id)
            ->where('reviewed_id', $this->executor_id);
    }

    /**
     * Отзыв от исполнителя на заказчика
     */
    public function executorReview(): \Illuminate\Database\Eloquent\Relations\HasOne
    {
        return $this->hasOne(Review::class, 'order_id')
            ->where('reviewer_id', $this->executor_id)
            ->where('reviewed_id', $this->user_id);
    }

    /**
     * Проверяет, может ли заказ быть оценен
     */
    public function canBeReviewed(): bool
    {
        return $this->status === self::STATUS_COMPLETED;
    }

    /**
     * Проверяет, может ли конкретный пользователь оставить отзыв
     */
    public function canBeReviewedByUser($userId): bool
    {
        if (!$this->canBeReviewed()) {
            return false;
        }
        
        // Проверяем, что пользователь является участником заказа
        if ($this->user_id !== $userId && $this->executor_id !== $userId) {
            return false;
        }
        
        // Если пользователь заказчик, проверяем, не оставил ли он уже отзыв на исполнителя
        if ($this->user_id === $userId) {
            return !$this->customerReview()->exists();
        }
        
        // Если пользователь исполнитель, проверяем, не оставил ли он уже отзыв на заказчика
        if ($this->executor_id === $userId) {
            return !$this->executorReview()->exists();
        }
        
        return false;
    }

    /**
     * Проверяет, оставил ли конкретный пользователь отзыв
     */
    public function hasReviewFromUser($userId): bool
    {
        if ($this->user_id === $userId) {
            return $this->customerReview()->exists();
        }
        
        if ($this->executor_id === $userId) {
            return $this->executorReview()->exists();
        }
        
        return false;
    }

    // Методы для управления статусами
    public function canBeCompleted(): bool
    {
        return in_array($this->status, [self::STATUS_IN_PROGRESS, self::STATUS_REVISION, self::STATUS_PENDING_REVIEW]);
    }

    public function canBeCompletedByExecutor(): bool
    {
        return in_array($this->status, [self::STATUS_IN_PROGRESS, self::STATUS_REVISION]);
    }

    public function canBeCompletedByCustomer(): bool
    {
        return in_array($this->status, [self::STATUS_IN_PROGRESS, self::STATUS_REVISION, self::STATUS_PENDING_REVIEW]);
    }

    public function canBeRevised(): bool
    {
        return in_array($this->status, [self::STATUS_IN_PROGRESS, self::STATUS_REVISION, self::STATUS_PENDING_REVIEW]);
    }

    public function canBeCancelled(): bool
    {
        return in_array($this->status, [self::STATUS_OPEN, self::STATUS_PENDING_APPROVAL, self::STATUS_IN_PROGRESS]);
    }

    public function canBeCancelledByExecutor(): bool
    {
        return in_array($this->status, [self::STATUS_OPEN, self::STATUS_PENDING_APPROVAL, self::STATUS_IN_PROGRESS, self::STATUS_PENDING_REVIEW]);
    }

    public function canBeCancelledByCustomer(): bool
    {
        return in_array($this->status, [self::STATUS_OPEN, self::STATUS_PENDING_APPROVAL, self::STATUS_IN_PROGRESS, self::STATUS_PENDING_REVIEW, self::STATUS_REVISION]);
    }

    public function canBeDisputed(): bool
    {
        return in_array($this->status, [self::STATUS_IN_PROGRESS, self::STATUS_REVISION]);
    }

    public function isCompleted(): bool
    {
        return $this->status === self::STATUS_COMPLETED;
    }

    public function isInProgress(): bool
    {
        return in_array($this->status, [self::STATUS_IN_PROGRESS, self::STATUS_REVISION]);
    }

    public function isCancelled(): bool
    {
        return $this->status === self::STATUS_CANCELLED;
    }

    // Получить статус для отображения
    public function getStatusDisplay(): string
    {
        $statuses = [
            self::STATUS_OPEN => 'Открыт',
            self::STATUS_PENDING_APPROVAL => 'На согласовании',
            self::STATUS_IN_PROGRESS => 'В работе',
            self::STATUS_PENDING_REVIEW => 'На проверке',
            self::STATUS_REVISION => 'На доработке',
            self::STATUS_COMPLETED => 'Завершен',
            self::STATUS_CANCELLED => 'Отменен',
            self::STATUS_DISPUTED => 'Спор',
        ];

        return $statuses[$this->status] ?? 'Неизвестно';
    }

    // Получить цвет статуса для UI
    public function getStatusColor(): string
    {
        $colors = [
            self::STATUS_OPEN => 'blue',
            self::STATUS_PENDING_APPROVAL => 'yellow',
            self::STATUS_IN_PROGRESS => 'green',
            self::STATUS_PENDING_REVIEW => 'purple',
            self::STATUS_REVISION => 'orange',
            self::STATUS_COMPLETED => 'green',
            self::STATUS_CANCELLED => 'red',
            self::STATUS_DISPUTED => 'red',
        ];

        return $colors[$this->status] ?? 'gray';
    }
}
