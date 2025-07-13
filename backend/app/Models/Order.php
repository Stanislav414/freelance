<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    protected $fillable = [
        'user_id', 'work_type_id', 'title', 'description', 'budget', 'deadline', 'status', 'type', 'goal', 'platform', 'format', 'orientation', 'sound'
    ];

    public function workType()
    {
        return $this->belongsTo(WorkType::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function attributes()
    {
        return $this->hasMany(OrderAttribute::class);
    }

    public function materials()
    {
        return $this->hasMany(OrderMaterial::class);
    }
}
