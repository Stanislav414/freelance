<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Tariff;
use App\Models\Service;
use App\Models\ServicePrice;
use Illuminate\Http\Request;

class TariffController extends Controller
{
    public function index()
    {
        $tariffs = Tariff::where('is_active', true)->get();
        return response()->json($tariffs);
    }

    public function getServicesByWorkType($workTypeId)
    {
        $services = Service::where('work_type_id', $workTypeId)
                          ->where('is_active', true)
                          ->get();

        $tariffs = Tariff::where('is_active', true)->get();

        // Добавляем цены к каждой услуге
        $servicesWithPrices = $services->map(function($service) use ($tariffs) {
            $prices = [];
            foreach ($tariffs as $tariff) {
                $servicePrice = ServicePrice::where('service_id', $service->id)
                                          ->where('tariff_id', $tariff->id)
                                          ->first();
                $prices[$tariff->id] = $servicePrice ? $servicePrice->price : 0;
            }
            $service->prices = $prices;
            return $service;
        });

        return response()->json([
            'services' => $servicesWithPrices
        ]);
    }

    public function getAdditionalOptions()
    {
        $options = [
            [
                'id' => 1,
                'name' => 'Срочность',
                'description' => 'Выполнение в течение 24 часов',
                'price' => 500
            ],
            [
                'id' => 2,
                'name' => 'Дополнительные правки',
                'description' => '3 правки включены',
                'price' => 250
            ],
            [
                'id' => 3,
                'name' => 'Исходные файлы',
                'description' => 'Предоставление исходников',
                'price' => 300
            ]
        ];

        return response()->json($options);
    }
}
