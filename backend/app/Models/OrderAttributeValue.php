<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class OrderAttributeValue extends Model
{
    protected $fillable = [
        'attribute_type_id', 'value', 'label', 'sort_order'
    ];

    public function attributeType()
    {
        return $this->belongsTo(OrderAttributeType::class, 'attribute_type_id');
    }
}
