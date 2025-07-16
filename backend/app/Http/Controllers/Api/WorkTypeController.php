<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\WorkType;

class WorkTypeController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return WorkType::all();
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
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

    public function attributes($id)
    {
        $workType = \App\Models\WorkType::with(['attributeTypes.values'])->findOrFail($id);
        $attrs = $workType->attributeTypes->map(function($attr) {
            $pivot = $attr->pivot;
            return [
                'id' => $attr->id,
                'name' => $attr->name,
                'label' => $attr->label,
                'required' => $pivot->required,
                'values' => $attr->values->map(fn($v) => ['id' => $v->id, 'label' => $v->label]),
            ];
        })->values();
        return response()->json($attrs);
    }
}
