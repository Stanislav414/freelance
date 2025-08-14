<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Tariff;
use App\Models\Service;
use App\Models\ServicePrice;
use App\Models\WorkType;

class TariffSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Обновляем/создаем тарифы (идемпотентно)
        $tariffsSeed = [
            ['name' => 'Базовый тариф', 'base_price' => 600, 'description' => 'Базовый набор услуг'],
            ['name' => 'Комфорт тариф', 'base_price' => 1300, 'description' => 'Расширенный набор услуг'],
            ['name' => 'Рич тариф', 'base_price' => 2000, 'description' => 'Премиум набор услуг'],
        ];

        foreach ($tariffsSeed as $tariffData) {
            Tariff::updateOrCreate(
                ['name' => $tariffData['name']],
                ['base_price' => $tariffData['base_price'], 'description' => $tariffData['description']]
            );
        }

        // Получаем типы работ
        $mpCardDesignWorkType = WorkType::where('name', 'Дизайн карточки для МП')->first();
        $businessCardWorkType = WorkType::where('name', 'Дизайн визитки')->first();
        $videoWorkType = WorkType::where('name', 'Видео')->first();

        // Создаем/обновляем услуги для "Дизайн карточки для МП"
        if ($mpCardDesignWorkType) {
            $mpServices = [
                [
                    'name' => 'Обложка для МП',
                    'description' => 'Создание обложки',
                    'work_type_id' => $mpCardDesignWorkType->id
                ],
                [
                    'name' => '1 слайд в карточке',
                    'description' => 'Один слайд презентации',
                    'work_type_id' => $mpCardDesignWorkType->id
                ]
            ];

            foreach ($mpServices as $serviceData) {
                Service::updateOrCreate(
                    ['work_type_id' => $serviceData['work_type_id'], 'name' => $serviceData['name']],
                    ['description' => $serviceData['description']]
                );
            }
        }

        // Создаем/обновляем услуги для "Дизайн визитки"
        if ($businessCardWorkType) {
            $businessCardServices = [
                [
                    'name' => 'Односторонняя визитка',
                    'description' => 'Дизайн односторонней визитки',
                    'work_type_id' => $businessCardWorkType->id
                ],
                [
                    'name' => 'Двухсторонняя визитка',
                    'description' => 'Дизайн двухсторонней визитки',
                    'work_type_id' => $businessCardWorkType->id
                ]
            ];

            foreach ($businessCardServices as $serviceData) {
                Service::updateOrCreate(
                    ['work_type_id' => $serviceData['work_type_id'], 'name' => $serviceData['name']],
                    ['description' => $serviceData['description']]
                );
            }
        }

        // Создаем/обновляем услуги для "Видео"
        if ($videoWorkType) {
            // Оставляем только "Видео с анимацией" и удаляем остальные услуги и их цены
            $keepName = 'Видео с анимацией';

            $otherVideoServices = Service::where('work_type_id', $videoWorkType->id)
                ->where('name', '!=', $keepName)
                ->get();

            foreach ($otherVideoServices as $svc) {
                ServicePrice::where('service_id', $svc->id)->delete();
                $svc->delete();
            }

            Service::updateOrCreate(
                ['work_type_id' => $videoWorkType->id, 'name' => $keepName],
                ['description' => 'Создание видео с анимацией']
            );
        }

        // Создаем цены для услуг
        $tariffs = Tariff::all();

        // Цены для "Дизайн карточки для МП"
        if ($mpCardDesignWorkType) {
            $mpServices = Service::where('work_type_id', $mpCardDesignWorkType->id)->get();
            
            foreach ($mpServices as $service) {
                foreach ($tariffs as $index => $tariff) {
                    $coverPrices = [600, 1300, 2000];
                    $slidePrices = [400, 1100, 1750];
                    
                    $basePrice = $service->name === 'Обложка для МП' ? 
                        $coverPrices[$index] ?? 600 : 
                        $slidePrices[$index] ?? 400;

                    ServicePrice::updateOrCreate(
                        ['service_id' => $service->id, 'tariff_id' => $tariff->id],
                        ['price' => $basePrice]
                    );
                }
            }
        }

        // Цены для "Дизайн визитки"
        if ($businessCardWorkType) {
            $businessCardServices = Service::where('work_type_id', $businessCardWorkType->id)->get();
            
            foreach ($businessCardServices as $service) {
                foreach ($tariffs as $index => $tariff) {
                    $oneSidePrices = [800, 1250, 3000];
                    $twoSidePrices = [1300, 1750, 4500];
                    
                    $basePrice = $service->name === 'Односторонняя визитка' ? 
                        $oneSidePrices[$index] ?? 800 : 
                        $twoSidePrices[$index] ?? 1300;

                    ServicePrice::updateOrCreate(
                        ['service_id' => $service->id, 'tariff_id' => $tariff->id],
                        ['price' => $basePrice]
                    );
                }
            }
        }

        // Цены для "Видео"
        if ($videoWorkType) {
            $videoServices = Service::where('work_type_id', $videoWorkType->id)->get();
            
            foreach ($videoServices as $service) {
                foreach ($tariffs as $index => $tariff) {
                    $animationVideoPrices = [2000, 4000, 6000];
                    
                    $basePrice = $animationVideoPrices[$index] ?? 2000;

                    ServicePrice::updateOrCreate(
                        ['service_id' => $service->id, 'tariff_id' => $tariff->id],
                        ['price' => $basePrice]
                    );
                }
            }
        }
    }
}
