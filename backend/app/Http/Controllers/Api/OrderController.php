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
        ]);

        $order = \App\Models\Order::create([
            'user_id' => $request->user()->id,
            'work_type_id' => $request->work_type_id,
            'title' => $request->title,
            'description' => $request->description,
            'budget' => $request->budget,
            'deadline' => $request->deadline,
            'status' => 'open',
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
        $order = \App\Models\Order::with([
            'workType',
            'materials',
            'attributes.value',
            'attributes.attributeType',
            'user'
        ])->find($id);

        if (!$order) {
            return response()->json(['message' => 'Order not found'], 404);
        }

        return response()->json($order);
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

    /**
     * Исполнитель берёт заказ в работу
     */
    public function take(Request $request, $id)
    {
        $user = $request->user();
        $order = \App\Models\Order::findOrFail($id);
        if ($order->status !== 'open') {
            return response()->json(['message' => 'Заказ уже в работе или закрыт'], 400);
        }
        $order->executor_id = $user->id;
        $order->status = 'in_progress';
        $order->save();
        return response()->json($order->load(['workType', 'materials', 'attributes.value', 'attributes.attributeType', 'user', 'executor']));
    }
}
