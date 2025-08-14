<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'surname',
        'email',
        'password',
        'avatar',
        'specialization',
        'specializations',
        'executor_description',
        'customer_description',
        'rating',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'specializations' => 'array',
        ];
    }

    /**
     * Заказы, где пользователь является исполнителем
     */
    public function orders()
    {
        return $this->hasMany(Order::class, 'executor_id');
    }

    /**
     * Отзывы, которые пользователь получил
     */
    public function receivedReviews()
    {
        return $this->hasMany(Review::class, 'reviewed_id');
    }

    /**
     * Отзывы, которые пользователь оставил
     */
    public function givenReviews()
    {
        return $this->hasMany(Review::class, 'reviewer_id');
    }

    /**
     * Лучшие работы в портфолио
     */
    public function portfolioWorks()
    {
        return $this->hasMany(PortfolioWork::class);
    }

    /**
     * Средний рейтинг пользователя
     */
    public function getAverageRatingAttribute()
    {
        return $this->receivedReviews()->where('is_public', true)->avg('rating') ?? 0;
    }

    /**
     * Количество отзывов
     */
    public function getReviewsCountAttribute()
    {
        return $this->receivedReviews()->where('is_public', true)->count();
    }

    /**
     * Отзывы, где пользователь является заказчиком (отзывы на него от исполнителей)
     */
    public function customerReviews()
    {
        return $this->hasMany(Review::class, 'reviewed_id')
            ->whereHas('order', function($query) {
                $query->where('user_id', $this->id); // Заказы, где пользователь - заказчик
            });
    }

    /**
     * Отзывы, где пользователь является исполнителем (отзывы на него от заказчиков)
     */
    public function executorReviews()
    {
        return $this->hasMany(Review::class, 'reviewed_id')
            ->whereHas('order', function($query) {
                $query->where('executor_id', $this->id); // Заказы, где пользователь - исполнитель
            });
    }

    /**
     * Средний рейтинг как заказчик
     */
    public function getAverageCustomerRatingAttribute()
    {
        return $this->customerReviews()->where('is_public', true)->avg('rating') ?? 0;
    }

    /**
     * Средний рейтинг как исполнитель
     */
    public function getAverageExecutorRatingAttribute()
    {
        return $this->executorReviews()->where('is_public', true)->avg('rating') ?? 0;
    }

    /**
     * Количество отзывов как заказчик
     */
    public function getCustomerReviewsCountAttribute()
    {
        return $this->customerReviews()->where('is_public', true)->count();
    }

    /**
     * Количество отзывов как исполнитель
     */
    public function getExecutorReviewsCountAttribute()
    {
        return $this->executorReviews()->where('is_public', true)->count();
    }
}
