<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class OrderAttribute extends Model
{
    protected $fillable = [
        'order_id', 'attribute_type_id', 'value_id', 'value'
    ];

    // Добавляем вычисляемое поле для текстового значения
    protected $appends = ['value_text'];

    public function getValueTextAttribute(): ?string
    {
        return $this->attributes['value'] ?? null;
    }

    public function order()
    {
        return $this->belongsTo(Order::class);
    }

    public function attributeType()
    {
        return $this->belongsTo(OrderAttributeType::class, 'attribute_type_id');
    }

    public function value()
    {
        return $this->belongsTo(OrderAttributeValue::class, 'value_id');
    }
}
