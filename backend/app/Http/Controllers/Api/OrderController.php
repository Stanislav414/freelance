<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return response()->json(
            \App\Models\Order::with(['workType', 'materials', 'attributes.value', 'user'])->get()
        );
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $data = $request->validate([
            'user_id' => 'required|exists:users,id',
            'work_type_id' => 'nullable|exists:work_types,id',
            'title' => 'required|string',
            'description' => 'nullable|string',
            'budget' => 'nullable|numeric',
            'deadline' => 'nullable|date',
            'status' => 'nullable|string',
            'attributes' => 'array',
            'attributes.*.attribute_type_id' => 'required|exists:order_attribute_types,id',
            'attributes.*.value_id' => 'required|exists:order_attribute_values,id',
            'materials' => 'array',
            'materials.*.type' => 'required|string',
            'materials.*.description' => 'nullable|string',
            'materials.*.file_url' => 'nullable|string',
            'type' => 'required|string',
            'goal' => 'required|string',
            'platform' => 'required|string',
            'format' => 'required|string',
            'orientation' => 'required|string',
            'sound' => 'required|string',
        ]);

        $order = \App\Models\Order::create([
            'user_id' => $request->user()->id,
            'work_type_id' => $request->work_type_id,
            'title' => $request->title,
            'description' => $request->description,
            'budget' => $request->budget,
            'deadline' => $request->deadline,
            'status' => 'open',
            'type' => $request->type,
            'goal' => $request->goal,
            'platform' => $request->platform,
            'format' => $request->format,
            'orientation' => $request->orientation,
            'sound' => $request->sound,
        ]);

        if (!empty($data['attributes'])) {
            foreach ($data['attributes'] as $attr) {
                $order->attributes()->create($attr);
            }
        }
        if (!empty($data['materials'])) {
            foreach ($data['materials'] as $mat) {
                $order->materials()->create($mat);
            }
        }
        return response()->json($order->load(['attributes.value', 'materials']), 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
