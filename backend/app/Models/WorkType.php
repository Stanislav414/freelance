<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class WorkType extends Model
{
    use HasFactory;

    protected $fillable = [
        'name', 'description', 'average_price', 'average_time', 'is_custom'
    ];

    public function orders()
    {
        return $this->hasMany(Order::class);
    }

    public function attributeTypes()
    {
        return $this->belongsToMany(OrderAttributeType::class, 'work_type_attribute_type', 'work_type_id', 'attribute_type_id')
            ->withPivot(['required', 'sort_order'])
            ->orderBy('work_type_attribute_type.sort_order');
    }
}
