<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Service extends Model
{
    protected $fillable = [
        'name',
        'description',
        'work_type_id',
        'is_active'
    ];

    protected $casts = [
        'is_active' => 'boolean',
    ];

    public function workType()
    {
        return $this->belongsTo(WorkType::class);
    }

    public function servicePrices()
    {
        return $this->hasMany(ServicePrice::class);
    }

    public function tariffs()
    {
        return $this->belongsToMany(Tariff::class, 'service_prices')
                    ->withPivot('price')
                    ->withTimestamps();
    }
}
