<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class OrderMaterial extends Model
{
    protected $fillable = [
        'order_id', 'type', 'description', 'file_url'
    ];

    public function order()
    {
        return $this->belongsTo(Order::class);
    }
}
