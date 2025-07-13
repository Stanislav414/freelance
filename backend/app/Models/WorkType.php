<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class WorkType extends Model
{
    protected $fillable = [
        'name', 'description', 'average_price', 'average_time', 'is_custom'
    ];

    public function orders()
    {
        return $this->hasMany(Order::class);
    }
}
