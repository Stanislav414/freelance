<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Отключаем проверки внешних ключей
        DB::statement('SET FOREIGN_KEY_CHECKS=0;');
        DB::table('order_attributes')->delete();
        DB::table('order_attribute_values')->delete();
        DB::table('order_attribute_types')->delete();
        DB::table('work_type_attribute_type')->delete();
        DB::table('work_types')->delete();
        DB::statement('SET FOREIGN_KEY_CHECKS=1;');

        // Типы заказов
        $videoTypeId = DB::table('work_types')->insertGetId([
            'name' => 'Видео до 30 секунд',
            'description' => 'Короткий видеоролик до 30 секунд',
            'average_price' => 2000,
            'average_time' => '2 дня',
            'is_custom' => false,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $photoTypeId = DB::table('work_types')->insertGetId([
            'name' => 'Цветокоррекция фото',
            'description' => 'Обработка и цветокоррекция фотографий',
            'average_price' => 500,
            'average_time' => '1 день',
            'is_custom' => false,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        // Атрибуты
        $attrs = [
            ['name' => 'type', 'label' => 'Тип ролика'],
            ['name' => 'goal', 'label' => 'Цель'],
            ['name' => 'platform', 'label' => 'Платформа'],
            ['name' => 'format', 'label' => 'Формат'],
            ['name' => 'sound', 'label' => 'Звук'],
            ['name' => 'orientation', 'label' => 'Ориентация'],
            ['name' => 'color_profile', 'label' => 'Цветовой профиль'],
        ];
        $attrIds = [];
        foreach ($attrs as $attr) {
            $attrIds[$attr['name']] = DB::table('order_attribute_types')->insertGetId([
                'name' => $attr['name'],
                'label' => $attr['label'],
                'sort_order' => 0,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }

        // Тип ролика
        $types = ['Рекламный', 'Блог', 'Презентация', 'Обзор', 'Другое'];
        foreach ($types as $i => $val) {
            DB::table('order_attribute_values')->insert([
                'attribute_type_id' => $attrIds['type'],
                'value' => strtolower($val),
                'label' => $val,
                'sort_order' => $i,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
        // Цель
        $goals = ['Презентация товара', 'Продвижение', 'Обучение', 'Развлечение', 'Другое'];
        foreach ($goals as $i => $val) {
            DB::table('order_attribute_values')->insert([
                'attribute_type_id' => $attrIds['goal'],
                'value' => strtolower($val),
                'label' => $val,
                'sort_order' => $i,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }

        // Значения для select-атрибутов (пример)
        $platforms = ['Instagram', 'TikTok', 'YouTube', 'VK', 'Другое'];
        foreach ($platforms as $i => $val) {
            DB::table('order_attribute_values')->insert([
                'attribute_type_id' => $attrIds['platform'],
                'value' => strtolower($val),
                'label' => $val,
                'sort_order' => $i,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
        $formats = ['1080p (Full HD)', '4K', '720p', 'JPEG', 'PNG', 'WEBP'];
        foreach ($formats as $i => $val) {
            DB::table('order_attribute_values')->insert([
                'attribute_type_id' => $attrIds['format'],
                'value' => strtolower($val),
                'label' => $val,
                'sort_order' => $i,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
        $orientations = ['Горизонтальная', 'Вертикальная', 'Квадратная'];
        foreach ($orientations as $i => $val) {
            DB::table('order_attribute_values')->insert([
                'attribute_type_id' => $attrIds['orientation'],
                'value' => strtolower($val),
                'label' => $val,
                'sort_order' => $i,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
        $sounds = ['Фоновая музыка', 'Без звука', 'Оригинальный звук'];
        foreach ($sounds as $i => $val) {
            DB::table('order_attribute_values')->insert([
                'attribute_type_id' => $attrIds['sound'],
                'value' => strtolower($val),
                'label' => $val,
                'sort_order' => $i,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
        $colorProfiles = ['sRGB', 'AdobeRGB', 'ProPhotoRGB'];
        foreach ($colorProfiles as $i => $val) {
            DB::table('order_attribute_values')->insert([
                'attribute_type_id' => $attrIds['color_profile'],
                'value' => strtolower($val),
                'label' => $val,
                'sort_order' => $i,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }

        // Связи work_type <-> attribute_type (и обязательность)
        // Для "Видео до 30 секунд"
        $videoAttrs = ['type', 'goal', 'platform', 'format', 'sound', 'orientation'];
        foreach ($videoAttrs as $i => $name) {
            DB::table('work_type_attribute_type')->insert([
                'work_type_id' => $videoTypeId,
                'attribute_type_id' => $attrIds[$name],
                'required' => true,
                'sort_order' => $i,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
        // Для "Цветокоррекция фото"
        $photoAttrs = ['color_profile'];
        foreach ($photoAttrs as $i => $name) {
            DB::table('work_type_attribute_type')->insert([
                'work_type_id' => $photoTypeId,
                'attribute_type_id' => $attrIds[$name],
                'required' => true,
                'sort_order' => $i,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }

        // Добавляем новый атрибут 'Анимация', если его нет
        if (!isset($attrIds['animation'])) {
            $attrIds['animation'] = DB::table('order_attribute_types')->insertGetId([
                'name' => 'animation',
                'label' => 'Анимация',
                'sort_order' => 0,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
        // Значения для 'Анимация'
        $animations = ['Нет', 'Простая', 'Сложная'];
        foreach ($animations as $i => $val) {
            DB::table('order_attribute_values')->insert([
                'attribute_type_id' => $attrIds['animation'],
                'value' => strtolower($val),
                'label' => $val,
                'sort_order' => $i,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
        // Новый тип заказа 'Оформление сторис'
        $storiesTypeId = DB::table('work_types')->insertGetId([
            'name' => 'Оформление сторис',
            'description' => 'Дизайн и оформление сторис для соцсетей',
            'average_price' => 1000,
            'average_time' => '1 день',
            'is_custom' => false,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        // Связи для сторис
        $storiesAttrs = ['platform', 'format', 'orientation', 'color_profile', 'animation'];
        foreach ($storiesAttrs as $i => $name) {
            DB::table('work_type_attribute_type')->insert([
                'work_type_id' => $storiesTypeId,
                'attribute_type_id' => $attrIds[$name],
                'required' => true,
                'sort_order' => $i,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }

        // --- ДОБАВЛЕНИЕ "Инфографика для МП" без удаления прошлых типов ---
        // Проверяем, есть ли уже такой тип
        $infographicType = DB::table('work_types')->where('name', 'Инфографика для МП')->first();
        if (!$infographicType) {
            $infographicTypeId = DB::table('work_types')->insertGetId([
                'name' => 'Инфографика для МП',
                'description' => 'Понятная и продающая инфографика для карточек товаров',
                'average_price' => 400,
                'average_time' => '3 часа',
                'is_custom' => false,
                'image' => 'infographic.png',
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        } else {
            $infographicTypeId = $infographicType->id;
        }
        // --- Атрибут marketplace ---
        $mpPlatforms = ['Ozon', 'Wildberries', 'Яндекс.Маркет', 'AliExpress', 'Другое'];
        $marketplaceAttr = DB::table('order_attribute_types')->where('name', 'marketplace')->first();
        if (!$marketplaceAttr) {
            $marketplaceAttrId = DB::table('order_attribute_types')->insertGetId([
                'name' => 'marketplace',
                'label' => 'Платформа (маркетплейс)',
                'sort_order' => 0,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
            foreach ($mpPlatforms as $i => $val) {
                DB::table('order_attribute_values')->insert([
                    'attribute_type_id' => $marketplaceAttrId,
                    'value' => strtolower($val),
                    'label' => $val,
                    'sort_order' => $i,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }
        } else {
            $marketplaceAttrId = $marketplaceAttr->id;
        }
        // --- Связи work_type <-> attribute_type для инфографики ---
        $attrIdsForInfographic = [
            $marketplaceAttrId
        ];
        // format, orientation, color_profile, animation могут быть созданы выше, ищем их id
        $attrNames = ['format', 'orientation', 'color_profile', 'animation'];
        foreach ($attrNames as $name) {
            $attr = DB::table('order_attribute_types')->where('name', $name)->first();
            if ($attr) $attrIdsForInfographic[] = $attr->id;
        }
        // Добавляем связи, если их нет
        foreach ($attrIdsForInfographic as $i => $attrId) {
            $exists = DB::table('work_type_attribute_type')
                ->where('work_type_id', $infographicTypeId)
                ->where('attribute_type_id', $attrId)
                ->first();
            if (!$exists) {
                DB::table('work_type_attribute_type')->insert([
                    'work_type_id' => $infographicTypeId,
                    'attribute_type_id' => $attrId,
                    'required' => true,
                    'sort_order' => $i,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }
        }
    }
}
