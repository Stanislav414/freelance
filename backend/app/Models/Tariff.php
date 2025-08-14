<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Tariff extends Model
{
    protected $fillable = [
        'name',
        'base_price',
        'description',
        'is_active'
    ];

    protected $casts = [
        'base_price' => 'decimal:2',
        'is_active' => 'boolean',
    ];

    public function servicePrices()
    {
        return $this->hasMany(ServicePrice::class);
    }

    public function orders()
    {
        return $this->hasMany(Order::class, 'selected_tariff_id');
    }
}
