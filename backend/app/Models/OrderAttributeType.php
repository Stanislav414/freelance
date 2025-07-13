<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class OrderAttributeType extends Model
{
    protected $fillable = [
        'name', 'label', 'sort_order'
    ];

    public function values()
    {
        return $this->hasMany(OrderAttributeValue::class, 'attribute_type_id');
    }
}
